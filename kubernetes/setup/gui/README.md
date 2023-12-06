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

#### Creating an NGINX reverse proxy

[Official docs](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/)

Install nginx

```bash
sudo apt install nginx
```

##### Generate TLS Certs

To secure the connection to our nginx proxy we will need to have TLS certificates that clients can use to encrypt their traffic.

Create a TLS certificate that nginx will use to secure incoming traffic to the server.

```bash
sudo mkdir -p /etc/nginx/certs
sudo chmod 700 /etc/nginx/certs

# generate client certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/server.key -out /etc/nginx/certs/server.crt
```

To have end-to-end encryption you may want to encrypt the traffic from nginx to the upstream Dashboard server. You can do so by following [this guide](https://docs.nginx.com/nginx/admin-guide/security-controls/securing-http-traffic-upstream/).

##### Create nginx reverse proxy

```nginx
# /etc/nginx/sites-available/reverse-proxy.nginx
server {
  listen 8989 ssl;
  listen [::]:8989 ssl;

  ssl_certificate /etc/nginx/certs/server.crt;
  ssl_certificate_key /etc/nginx/certs/server.key;

  location / {
    proxy_pass https://127.0.0.1:8443/;
  }
}
```

Enable the reverse proxy

```bash
sudo ln -s /etc/nginx/sites-available/reverse-proxy.nginx /etc/nginx/sites-enabled/reverse-proxy.nginx
```

Check the implementation

```bash
sudo nginx -t
```

If all looks good, start the server

```bash
sudo systemctl reload nginx
```

[Official docs](https://github.com/kubernetes/dashboard/blob/master/docs/user/accessing-dashboard/README.md)

##### Enable Kubernetes proxy

Create a script to run the K8s Dashboard.

```bash
# dashboard.sh
export POD_NAME=$(kubectl get pods -n kubernetes-dashboard -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=kubernetes-dashboard" -o jsonpath="{.items[0].metadata.name}")

echo https://127.0.0.1:8443/

kubectl -n kubernetes-dashboard port-forward $POD_NAME 8443:8443
```

##### Connect to the Dashboard

To connect to the dashboard run the script above

```bash
chmod +x dashboard.sh

./dashboard.sh
```

You should now be able to connect to the Dashboard from a remote machine that can connect to the Dashboard host

```bash
https://<HOST>:8989
```

### Create a user

[Official docs](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)

**WARNING: Granting admin privileges to Dashboard's service accounts might be a security risk.**

[Learn more about access control](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/README.md)

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

Create the user and role

```bash
kubectl create -f dashboard-adminuser.yaml
```

#### Getting a Bearer Token for ServiceAccount

Create the token we can use to log in

```bash
kubectl -n kubernetes-dashboard create token admin-user
```

You can specify how long the token should be alive for using the `--duration` flag.

For more information on creating API tokens, check the [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-an-api-token-for-a-serviceaccount).

[Check here](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account) for creating **long-lived tokens**.
