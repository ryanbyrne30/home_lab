# Configuring a K8s Cluster

## Steps

1. [Configure and setup your K8s control plane](#configuring-the-kubelet-cgroup-driver)
2. [Install a K8s Pod network add-on](#install-a-k8s-pod-network-add-on)

## Setting Up K8s Control Plane

### Configuring the kubelet cgroup driver

In this configuration we are using the `systemd` cgroup driver from the [installation process](../installation/README.md). As such we will need to configure the control plane to use the `systemd` cgroup driver as well.

From the [docs](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/#configuring-the-kubelet-cgroup-driver), you can use the configuration below as a minimal configuration for `kubeadm init`:

```yaml
# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.28.4
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
```

This can be passed in by running

```bash
kubeadm init --config kubeadm-config.yaml
```

## Install a K8s Pod network add-on

[Official docs](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network)

In order for pods to communicate with eachother you must install a Pod network add-on.

[See here](https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy) for a list of some Container Network Interfaces (CNIs) for K8s.

### [Installing Calico](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises)

Checkout [calico.sh](scripts/calico.sh)

1. [Install the Calico operator](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises)