# Nginx Ingress

[Official docs](https://kubernetes.github.io/ingress-nginx/deploy/)

A K8s ingress allows remote connections to your cluster.

## Deploy the ingress controller

```bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

## Create ingress rule

```bash
kubectl create ingress demo --class=nginx \
  --rule="www.demo.io/*=demo:80"
```
