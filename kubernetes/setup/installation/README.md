# Installing Kubernetes

**Note:** In order for K8s to function properly, all versions of `kubeadm`, `kubelet` and `kubectl` must be of the **same verion**.

## Prerequisites

Before installing Kubernetes, make sure your host machine meets the [minimum requirements](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin).

## Steps

Steps are listed out below. See `install.sh` for the set of commands (these may need to be updated periodically according to the [documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm))

1. [Install a container runtime](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
   - According to the [docs](https://kubernetes.io/docs/setup/production-environment/container-runtimes/), for a system running `system` (like Ubuntu), you should avoid using the `cgroupfs` driver in favor of `systemd` which uses the `cgroupfs` driver under the hood. Changing the cgroup driver is a risky operation, and it is recommended to backup K8s and reinstall K8s with the correct cgroup driver
   - Commands shown in [container_runtime.sh](scripts/container_runtimes.sh) - configured for Ubuntu - `containerd` and `systemd`
2. Disable SWAP memory on host
   - See [disable_swap.sh](scripts/disable_swap.sh)
3. [Install kubeadm, kubectl and kubelet](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)

   - Check [this list](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) to see host compatability requirements
   - see [k8s_tools.sh](scripts/k8s_tools.sh)
