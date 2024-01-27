# [Prometheus](https://prometheus.io)

Time series metrics

## [Installing with Helm](https://github.com/prometheus-community/helm-charts)

Add the repo

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

Search the repo

```bash
helm search repo prometheus-community
```

### [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)

Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.

```bash
helm install [RELEASE_NAME] prometheus-community/kube-prometheus-stack
```

Uninstalling

```bash
helm uninstall [RELEASE_NAME]

kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheusagents.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd scrapeconfigs.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com
```

Show configuration options

```bash
helm show values prometheus-community/kube-prometheus-stack
```
