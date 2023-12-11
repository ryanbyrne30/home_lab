# Settings up a RKE2 <!-- omit from toc -->

[Official docs](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-cluster-setup/rke2-for-rancher)

## Contents <!-- omit from toc -->

- [Prerequisites](#prerequisites)
- [Installing Kubernetes](#installing-kubernetes)
  - [Set Up the RKE2 server](#set-up-the-rke2-server)
    - [Auth Token](#auth-token)
    - [Configuration](#configuration)
    - [Install](#install)
  - [Joining additional control plane nodes](#joining-additional-control-plane-nodes)
  - [Confirm RKE2 is Running](#confirm-rke2-is-running)
  - [Using the kubeconfig File with kubectl](#using-the-kubeconfig-file-with-kubectl)
- [Joining Worker Nodes](#joining-worker-nodes)

## Prerequisites

- Set up 3 nodes, load balancer and a DNS record [reference](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/infrastructure-setup/ha-rke2-kubernetes-cluster)
  - [Set up an nginx load balancer](../../../nginx/load_balancer.md)
- Note that in order for RKE2 to work correctly with the load balancer, you need to set up two listeners: one for the supervisor on **port 9345**, and one for the Kubernetes API on **port 6443**

## Installing Kubernetes

### Set Up the [RKE2](https://docs.rke2.io/) server

RKE2 runs with embdedded etcd (service discovery).

#### Auth Token

On the first node, you should set up the configuration file with your own pre-shared secret as the token. The token argument can be set on startup.

If you do not specify a pre-shared secret, RKE2 will generate one and place it at `/var/lib/rancher/rke2/server/node-token`.

#### Configuration

To avoid certificate errors with the fixed registration address, you should launch the server with the `tls-san` parameter set. This option adds an additional hostname or IP as a Subject Alternative Name in the server's TLS cert, and it can be specified as a list if you would like to access via both the IP and the hostname.

Create the directory where the RKE2 config file will be placed

```bash
sudo mkdir -p /etc/rancher/rke2
```

Create a config file at `/etc/rancher/rke2/config.yaml`

```yaml
# /etc/rancher/rke2/config.yaml

token: my-shared-secret
tls-san:
  - rancher.homelab
  #- another-kubernetes-domain.com
```

#### Install

Run the install command and enable and start rke2

```bash
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service
```

### Joining additional control plane nodes

In order to function properly, an RKE2 cluster must have an **odd number of control plane nodes**.

To join additional nodes, configure each node with the same shared token. On each node

```yaml
# /etc/rancher/rke2/config.yaml
token: my-shared-secret
server: https://<DNS-DOMAIN>:9345
tls-san:
  - rancher.homelab
  #- another-kubernetes-domain.com
```

Example

```yaml
# /etc/rancher/rke2/config.yaml
token: my-shared-secret
server: https://192.168.1.16:9345
tls-san:
  - rancher.homelab
  #- another-kubernetes-domain.com
```

Run the installer and enable, then start rke2

```bash
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service
```

### Confirm RKE2 is Running

```bash
/var/lib/rancher/rke2/bin/kubectl \
        --kubeconfig /etc/rancher/rke2/rke2.yaml get nodes
You should see your server nodes in the Ready state.
```

Check pod health

```bash
/var/lib/rancher/rke2/bin/kubectl \
        --kubeconfig /etc/rancher/rke2/rke2.yaml get pods --all-namespaces
```

### Using the kubeconfig File with kubectl

When you installed RKE2 on each Rancher server node, a `kubeconfig` file was created on the node at `/etc/rancher/rke2/rke2.yaml`. This file contains credentials for full access to the cluster, and you should save this file in a secure location.

Using the `kubeconfig` file:

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/#install-kubectl)
2. Copy `/etc/rancher/rke2/rke2.yaml` to `~/.kube/config`
3. (Optional - if control plane is running on a different node) Change the `server` directive from `localhost` to the DNS configured in the load balancer (`rancher.homelab`) on port 6443

Example `rke2.yaml` config file

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: [CERTIFICATE-DATA]
    server: [LOAD-BALANCER-DNS]:6443 # Edit this line
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    password: [PASSWORD]
    username: admin
```

## Joining Worker Nodes

[Reference docs](https://docs.rke2.io/install/quickstart#linux-agent-worker-node-installation)

**Each machine must have a unique hostname.**

Run the installer (run as `root`)

```bash
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
```

Enable the `rke2-agent` service

```bash
systemctl enable rke2-agent.service
```

Configure the rke2-agent service

```bash
mkdir -p /etc/rancher/rke2/
vim /etc/rancher/rke2/config.yaml
```

```bash
# /etc/rancher/rke2/config.yaml

server: https://<server>:9345
token: <token from server node>
```

_Auth token can be found from the [step above](#auth-token)_

Start the service

```bash
systemctl start rke2-agent.service
```
