# SonarQube Installation

[Official docs](https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server/introduction/)

## K8s Installation with Helm

### Install SonarQube database

[Official docs](https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server/installing-the-database/)

[Install PostgreSQL](https://ubuntu.com/server/docs/databases-postgresql)

Connect to Postgres and change default password

```bash
sudo -u postgres psql
```

```sql
ALTER USER postgres with encrypted password 'mypassword';
```

Create schema and user

```sql
CREATE SCHEMA sonarqube_schema;
CREATE USER sonarqube;
ALTER USER sonarqube SET search_path TO sonarqube_schema;
GRANT ALL ON SCHEMA sonarqube_schema TO sonarqube;
```

### Installing the SonarQube chart

[Official docs](https://github.com/SonarSource/helm-chart-sonarqube/tree/master/charts/sonarqube)

```bash
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
kubectl create namespace sonarqube
helm upgrade --install -n sonarqube sonarqube sonarqube/sonarqube
```

Default login `admin/admin`

Get the application URL by running these commands:

```bash
export POD_NAME=$(kubectl get pods --namespace sonarqube -l "app=sonarqube,release=sonarqube" -o jsonpath="{.items[0].metadata.name}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl port-forward $POD_NAME 8080:9000 -n sonarqube
```

## Uninstalling

```bash
helm list
helm delete <sonarqube-name>
```
