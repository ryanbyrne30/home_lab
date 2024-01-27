# [Argo CD](https://argo-cd.readthedocs.io)

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

## Prerequisites

- [Kubernetes installed](../Kubernetes/README.md)
- `kubectl` installed
- `CoreDNS` enabled for K8s

## Installation

Create K8s Resources

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

[Install CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/#download-with-curl)

```bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

[Enable access to Argo CD API externally](https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#kubernetesingress-nginx)

_Can create an ingress for `argocd-server` with the following configurations:_

- Ingress class: `nginx`
- Annotations
  - `nginx.ingress.kubernetes.io/backend-protocol`: `HTTPS`
  - `nginx.ingress.kubernetes.io/force-ssl-redirect`: `true`
  - `nginx.ingress.kubernetes.io/ssl-passthrough`: `true`
- Rules
  - Target service: `argocd-server`
  - Target port: `443`

You should then be able to access the ArgoCD Dashboard UI defined by your NGINX config.

To login, first get the initial password:

```bash
argocd admin initial-password -n argocd
```

⚠️ This password is stored in `argocd-initial-admin-secret` and should be deleted after changing this password.

The default user is `admin`
