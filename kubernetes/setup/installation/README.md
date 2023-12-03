# Installing Kubernetes

**Note:** In order for K8s to function properly, all versions of `kubeadm`, `kubelet` and `kubectl` must be of the **same verion**.

## Prerequisites

Before installing Kubernetes, make sure your host machine meets the [minimum requirements](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin).

## Steps

Steps are listed out below. See `install.sh` for the set of commands (these may need to be updated periodically according to the [documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm))

1. [Install kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

   - Check [this list](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) to see host compatability requirements
   - **Swap memory must be disabled** (see `scripts/disable_swap.sh`)
