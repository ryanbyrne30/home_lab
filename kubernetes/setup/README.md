# Setting Up Kubernetes (Production)

Kubernetes (K8s) utilizes three tools to manage a cluster:

- `kubeadm`: command to bootstrap the cluster
- `kubelet`: the component that runs on all of the machines in your cluster and does things like starting pods and containers.
- `kubectl`: the command line util to talk to your cluster.

**Note:** In order for K8s to function properly, all versions of `kubeadm`, `kubelet` and `kubectl` must be of the **same verion**.

## How it works

Kubernetes works by having a dedicated host serve as the **control plane**. This is responsible for managing cluster activity. Other hosts can run nodes that can integrate with the control plane. The culmination of all of the nodes associated with a control plane is called a **cluster**.

In order for this to work, you will need to have multiple machines (VMs or bare metal) capable of running Kubernetes. An easy way to get setup is to have a bare metal host running [Proxmox Virtual Environment](../../proxmox_ve/README.md). This will allow you to spin up multiple VMs quickly on the same machine.

## Steps

1. [Install Kubernetes](installation/README.md) - applies to all hosts
2. [Setup K8s Control Plane](control_plane/README.md) - applies to host responsible for management of the cluster
3. [Add K8s Node to Cluster](control_plane/README.md#add-nodes-to-cluster) - applies to hosts responsible for running applications
4. [(Optional) Setup K8s Dashboard](gui/README.md)
