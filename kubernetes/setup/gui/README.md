# Accessing the K8s Dashboard

[Official docs of Kubernetes Dashboard project](https://github.com/kubernetes/dashboard)

[Reference docs](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)

This document covers how to access K8s with the dashboard UI

## Prerequisites

- Have `helm` installed (see the [installation guide](https://helm.sh/docs/intro/install))

## Steps

1. [Deploy the dashboard](#deploy-the-dashboard)
2. [Create a user](#create-a-user)

### Deploy the dashboard

[Official docs](https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard#installing-the-chart)

Using helm

```bash
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```

Watch the setup

```bash
watch kubectl get pods -n kubernetes-dashboard
```

### Exposing the dashboard

[Official docs](https://github.com/kubernetes/dashboard/blob/master/docs/user/accessing-dashboard/README.md)

```bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-nginx-controller 8443:443
```

Get the Kubernetes Dashboard URL:

```bash
export POD_NAME=$(kubectl get pods -n kubernetes-dashboard -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=kubernetes-dashboard" -o jsonpath="{.items[0].metadata.name}")

echo https://127.0.0.1:8443/

kubectl -n kubernetes-dashboard port-forward $POD_NAME 8443:8443
```

### Create a user

[Official docs](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#accessing-the-dashboard-ui)

**WARNING: Granting admin privileges to Dashboard's service accounts might be a security risk.**

Currently, Dashboard only supports logging in with a Bearer Token.

#### Creating a Service Account

Create a service accoutn with the name `admin-user` in the namespace `kubernetes-dashboard`

```yaml
# dashboard-adminuser.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```

Learn more about [creating service accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account)

#### Creating a ClusterRoleBinding

Usually the `ClusterRole` `cluster-admin` already exists after a cluster has been provisioned. If it does not exist, create it and grant the required privileges.

```yaml
# dashboard-adminuser.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kubernetes-dashboard
```

#### Getting a Bearer Token for ServiceAccount

Run the following to create the resources above

```bash
kubectl create -f dashboard-adminuser.yaml
```

Next we create the token we can use to log in

```bash
kubectl -n kubernetes-dashboard create token admin-user
```

You can specify how long the token should be alive for using the `--duration` flag.

For more information on creating API tokens, check the [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-an-api-token-for-a-serviceaccount).

[Check here](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account) for creating **long-lived tokens**.

#### Accessing the Dashboard

[Official docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account)

Enable access to the Dashboard

```
kubectl proxy
```

The Dashboard will now be available at http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
