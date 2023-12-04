# Setting Up Kubernetes (Production)

Kubernetes (K8s) utilizes three tools to manage a cluster:

- `kubeadm`: command to bootstrap the cluster
- `kubelet`: the component that runs on all of the machines in your cluster and does things like starting pods and containers.
- `kubectl`: the command line util to talk to your cluster.

**Note:** In order for K8s to function properly, all versions of `kubeadm`, `kubelet` and `kubectl` must be of the **same verion**.

## Steps

1. [Install Kubernetes](installation/README.md)
2. [Configure Kubernetes](configuration/README.md)
