# Setting Up K8s Control Plane

## Steps

1. [Configure and setup your K8s control plane](#configuring-the-kubelet-cgroup-driver)
2. [Install a K8s Pod network add-on](#install-a-k8s-pod-network-add-on)
3. [Add nodes to cluster](#add-nodes-to-cluster)

### Configuring the kubelet cgroup driver

In this configuration we are using the `systemd` cgroup driver from the [installation process](../installation/README.md). As such we will need to configure the control plane to use the `systemd` cgroup driver as well.

From the [docs](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#configuring-the-kubelet-cgroup-driver), you can use the configuration below as a minimal configuration for `kubeadm init`:

```yaml
# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.28.4
networking:
  podSubnet: "10.0.0.0/16" # --pod-network-cidr
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
```

This can be passed in by running

```bash
kubeadm init --config kubeadm-config.yaml
```

In order to run `kubeadm init` again, you must first tear down your cluster. See [kubernetes/cleanup](../../cleanup/README.md).

## Install a K8s Pod network add-on

[Official docs](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network)

In order for pods to communicate with eachother you must install a Pod network add-on.

[See here](https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy) for a list of some Container Network Interfaces (CNIs) for K8s.

### [Installing Calico](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises)

#### Prerequisites

- Make sure your host meets the [minimum requirements](https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart#before-you-begin)
- If your host uses `NetworkManager`, [configure NetworkManager](https://docs.tigera.io/calico/latest/operations/troubleshoot/troubleshooting#configure-networkmanager)

#### Install Calico

Reference: [Quickstart guide](https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart)

1. [Install the Calico operator](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises)
   - see [calico_operator.sh](scripts/calico_operator.sh)
2. [Install calicoctl](https://docs.tigera.io/calico/latest/operations/calicoctl/install)
   - see [calicoctl.sh](scripts/calicoctl.sh)

### Add Nodes to Cluster

[Official docs](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#join-nodes)

1. SSH into machine hosting node you want to add
2. Become root (`sudo su -`)
3. Install a [container runtime (CRI)](../installation/README.md#steps) if needed
4. Run the command that was output by `kubeadm init`:

```bash
kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>
```

If you do not have the token, run

```bash
kubeadm token list
```

These tokens expire after 24 hours, so if yours has expired you can generate a new one

```bash
kubeadm token create
```

If you don't have the value of `--discovery-token-ca-cert-hash` you can get it from

```bash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```

**Note**: the hostnames of each node must be unique. [Change the hostname of your linux server](https://www.cyberciti.biz/faq/ubuntu-change-hostname-command/).

See `kubeadm join` [docs](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/)

## What's Next?

[Setup the Kubernetes Dashboard](../gui/README.md)
