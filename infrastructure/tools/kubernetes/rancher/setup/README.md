# Setup Rancher for a K8s Cluster <!-- omit from toc -->

[Reference](https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster)

## Content <!-- omit from toc -->

- [Prerequisites](#prerequisites)
- [Install the Rancher Helm Chart](#install-the-rancher-helm-chart)
  - [Add the Helm Chart Repo](#add-the-helm-chart-repo)
  - [Create a Namespace for Rancher](#create-a-namespace-for-rancher)
  - [Configure SSL](#configure-ssl)
  - [Install Rancher with Helm and Certs](#install-rancher-with-helm-and-certs)
- [Access Rancher](#access-rancher)

## Prerequisites

- Set up a Kubernetes cluster
  - [RKE2 setup](rke2_cluster.md)
- [Set up an ingress controller](https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster#ingress-controller)
  - For RKE, RKE2, and K3s installations, you don't have to install the Ingress controller manually because one is installed by default.
- CLI tools are installed
  - `kubectl`
  - `helm`

## Install the Rancher Helm Chart

### [Add the Helm Chart Repo](https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster#1-add-the-helm-chart-repository)

```bash
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
```

### Create a Namespace for Rancher

Create the namespace `cattle-system`

```bash
kubectl create namespace cattle-system
```

### Configure SSL

[Other options](https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster#3-choose-your-ssl-configuration) exist for SSL configuration including Let's Encrypt (for public DNS's) and bring your own certs. Here we will let rancher handle the certs using `cert-manager`.

[Official cert-manager install docs](https://cert-manager.io/docs/releases/#installing-with-helm)

```bash
# If you have installed the CRDs manually instead of with the `--set installCRDs=true` option added to your Helm install command, you should upgrade your CRD resources before upgrading the Helm chart:

# Check latest VERSION that supports your K8s version from the official cert-manager install docs above
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/<VERSION>/cert-manager.crds.yaml

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace
```

Verify `cert-manager` is deployed correctly

```bash
kubectl get pods --namespace cert-manager

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-5c6866597-zw7kh               1/1     Running   0          2m
cert-manager-cainjector-577f6d9fd7-tr77l   1/1     Running   0          2m
cert-manager-webhook-787858fcdb-nlzsq      1/1     Running   0          2m
```

### [Install Rancher with Helm and Certs](https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster#5-install-rancher-with-helm-and-your-chosen-certificate-option)

Installs may vary based on how certs were installed. We will continue based on a Rancher managed cert solution. [See instructions](https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster#5-install-rancher-with-helm-and-your-chosen-certificate-option) for alternative methods.

- Set the `hostname` to the DNS name you pointed at your load balancer
- Set the `bootstrapPassword` to something unique for the `admin` user
- To install a specific Rancher version, use `--version` flag (`--version 2.7.0`)

```bash
helm install rancher rancher-<CHART_REPO>/rancher \
  --namespace cattle-system \
  --set hostname=HOSTNAME \
  --set bootstrapPassword=MY_PASSWORD
```

Example:

```bash
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.homelab.local \
  --set bootstrapPassword=MY_PASSWORD
```

Verify Rancher deployment

```bash
kubectl -n cattle-system rollout status deploy/rancher

Waiting for deployment "rancher" rollout to finish: 0 of 3 updated replicas are available...
deployment "rancher" successfully rolled out
```

```bash
kubectl -n cattle-system rollout status deploy/rancher

kubectl -n cattle-system get deploy rancher
```

## Access Rancher

If all went well you should be able to access Rancher using the DNS name you configured on your load balancer (`rancher.homelab.local`).

Login with the bootstrapped password or run this to get the password

```bash
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
```
