# Istio

## Setup

[docs](https://istio.io/latest/docs/setup/getting-started/#download)

1. Download Istio

```bash
curl -L https://istio.io/downloadIstio | sh -
```

2. Move to the Istio package directory

```bash
cd istio-1.20.0
```

3. Add `istioctl` client to path

```bash
export PATH=$PWD/bin:$PATH
```

## Install Istio

[docs](https://istio.io/latest/docs/setup/getting-started/#download)

Install Istio with a [profile](https://istio.io/latest/docs/setup/additional-setup/config-profiles/). In this case we will choose `default` for production use.

```bash
istioctl install --set profile=default -y
```

Add namespace label -> instructs Istio to inject Envoy sidecar proxies

```bash
kubectl label namespace default istio-injection=enabled
```

## View the dashboard

Install [Kiali](https://istio.io/latest/docs/ops/integrations/kiali/) and other addons

```bash
kubectl apply -f samples/addons
kubectl rollout status deployment/kiali -n istio-system
```

Access the Kiali dashboard

```bash
istioctl dashboard kiali
```
