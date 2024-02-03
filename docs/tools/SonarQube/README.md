# SonarQube <!-- omit in toc -->

[Official docs](https://docs.sonarsource.com/sonarqube/latest/)

SonarQube is a self-managed, automatic code review tool that systematically helps you deliver Clean Code. As a core element of our Sonar solution, SonarQube integrates into your existing workflow and detects issues in your code to help you perform continuous code inspections of your projects. The product analyses 30+ different programming languages and integrates into your Continuous Integration (CI) pipeline of DevOps platforms to ensure that your code meets high-quality standards.

## Contents<!-- omit in toc -->

- [Install](#install)
  - [Install on K8s](#install-on-k8s)
    - [Create SonarQube PersistentVolume](#create-sonarqube-persistentvolume)
    - [Install SonarQube](#install-sonarqube)
      - [Troubleshooting](#troubleshooting)
        - [Postgres pod not starting](#postgres-pod-not-starting)
        - [SonarQube pod not starting](#sonarqube-pod-not-starting)
        - [SonarQube pod backing off](#sonarqube-pod-backing-off)
- [Connecting to SonarQube](#connecting-to-sonarqube)
  - [Add a Certificate for SonarQube](#add-a-certificate-for-sonarqube)
  - [Add Ingress Using Rancher Dashboard](#add-ingress-using-rancher-dashboard)
- [SonarLint](#sonarlint)
- [Setting Up Encryption](#setting-up-encryption)

## Install

### [Install on K8s](https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/deploy-on-kubernetes/deploy-sonarqube-on-kubernetes/)

[See the Rancher docs for getting started with K8s](../Kubernetes/rancher/README.md)

#### Create SonarQube PersistentVolume

There are many [different ways](https://kubernetes.io/docs/concepts/storage/persistent-volumes) to persist data in K8s. In this example we will be using a file path on a node's host machine to persist SonarQube data. You can use other methods that are more secure/persistent, however, since SonarQube is not super critical this is the easiest and cheapest solution.

```yaml
# sonarqube-pv.yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: sonarqube-pv
spec:
  capacity:
    storage: 30Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  local:
    path: /path/on/node/host # change this
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - HOSTNAME_OF_NODE_HOST # and this
```

```bash
kubectl create -f sonarqube-pv.yaml
```

#### Install SonarQube

Configure host for Elastisearch
[Reference](https://stackoverflow.com/questions/51445846/elasticsearch-max-virtual-memory-areas-vm-max-map-count-65530-is-too-low-inc)

```bash
sysctl -w vm.max_map_count=262144
```

Install the Helm chart

```bash
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
kubectl create namespace sonarqube
helm upgrade --install -n sonarqube sonarqube sonarqube/sonarqube
```

[Additional configuration options](https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/deploy-on-kubernetes/deploy-sonarqube-on-kubernetes/)

Following install you will be greeted by

```bash
Get the application URL by running these commands:
export POD_NAME=$(kubectl get pods --namespace sonarqube -l "app=sonarqube,release=sonarqube" -o jsonpath="{.items[0].metadata.name}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl port-forward $POD_NAME 8080:9000 -n sonarqube
```

##### Troubleshooting

###### Postgres pod not starting

If your postgres pod for sonarqube is not starting up, you may need to increase the disk size available in your persistent volume.

###### SonarQube pod not starting

If your sonarqube pod is not starting up, you may need more CPU capacity (`2 CPUs`) and memory (`4GB RAM`).

###### SonarQube pod backing off

If your sonarqube pod is saying `Back-off restarting failed container` and `kubectl logs sonarqube-sonarqube-0 -n sonarqube` mentions `max virtual memory areas vm.max_map_count [65530] is too low` you need to increase this memory value on the node's host.

```bash
sysctl -w vm.max_map_count=262144
```

## Connecting to SonarQube

### Add a Certificate for SonarQube

[Reference](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-resources-setup/encrypt-http-communication)

Follow [these steps](../../concepts/tls-certificates.md#using-lets-encrypt) to create a TLS certificate and key using Let's Encrypt for your domain.

Add the TLS certificate and key to the NGINX reverse proxy.

In your Rancher dashboard, under "Secrets" add the certificate and key you just created.

You can then add the TLS secret to the ingress for SonarQube. The TLS certificates should match between the ingress and the reverse proxy.

### Add Ingress Using Rancher Dashboard

In your Rancher dashboard, open the project your SonarQube instance exists in (`local`). Under "Service Discovery" open "Ingresses". Choose the appropriate values for your SonarQube service. Typically they will be:

- Namespace: `sonarqube`
- Name: `sonarqube` (or anything you want)
- Request Host: `sonarqube.homelab` (or any DNS name you want)
- Path Prefix: `/`
- Target Service: `sonarqube-sonarqube`
- Port: `9000`

Under `Certificates`, add the certificate you created previously.

You should now be able to access SonarQube at `sonarqube.homelab.local`.

If you can't, update your `/etc/hosts` file and add a record that points `sonarqube.homelab.local` at your load balancer (or the host that is running your [nginx load balancer](../NGINX/load_balancer.md)).

The default login is `admin/admin`.

## SonarLint

In VSCode, install SonarLint and add a connection to SonarQube. It should ask you to trust the CA we created earlier.

## [Setting Up Encryption](https://docs.sonarsource.com/sonarqube/9.9/instance-administration/security/#settings-encryption)

Go to the SonarQube dashboard **Administration** > **Configuration** > **Encryption** and generate an encryption key.

Create a secret with the key value pair:
`sonar-secret.txt` = `ENCRYPTION_KEY`

On the host create a file `values.yaml` and update the SonarQube helm chart with the secret.

```yaml
# values.yaml
sonarSecretKey: NAME_OF_SECRET_CREATED_PRIOR
```

```bash
helm upgrade -n sonarqube -f values.yaml sonarqube sonarqube/sonarqube
```

You may need to restart the SonarQube deployment to see the changes. Other configurations can be found [here](https://github.com/SonarSource/helm-chart-sonarqube/tree/master/charts/sonarqube).
