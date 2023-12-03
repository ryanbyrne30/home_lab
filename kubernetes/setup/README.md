# Steps

1. [Install kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

   - Check [this list](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin) to see host compatability requirements
   - **Swap memory must be disabled**

2. [Download Kubernetes](https://kubernetes.io/docs/setup/)

   - [kubectl](https://kubernetes.io/releases/download/)
     - Used to run commands against a K8s cluster
     - You must use a kubectl version that is within one minor version difference of your cluster. For example, a v1.28 client can communicate with v1.27, v1.28, and v1.29 control planes. Using the latest compatible version of kubectl helps avoid unforeseen issues.
