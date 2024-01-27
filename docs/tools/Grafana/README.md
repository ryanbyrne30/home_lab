# [Grafana](https://grafana.com/)

Open source dashboards to integrate into your home lab.

## [Install on Kubernetes](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md)

```bash
# Add the repo
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Grafana
helm install my-release grafana/grafana
```

### Uninstalling

```bash
helm delete my-release
```

## Signing In

By default Grafana is hosted either `http://localhost:3000` or if installed with helm on port `80`.

The default login is `admin/admin` or from the helm distribution, the password is stored in a secret.
