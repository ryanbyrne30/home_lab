# Cleanup Kubernetes Cluster

[Reference](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down)

## Steps

1. [Remove the node](#remove-the-node)

### Remove the Node

Talking to the control-plane node with the appropriate credentials, run:

```bash
kubectl drain <node name> --delete-emptydir-data --force --ignore-daemonsets
```

Reset the state of `kubeadm`

```bash
kubeadm reset
```

Reset iptables

```bash
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
```

Reset IPVS tables

```bash
ipvsadm -C
```

Remove the node

```bash
kubectl delete node <node name>
```

**Note:** You may also need to delete the folder `$HOME/.kube` if you run into an X509 Certificate Error in the future.

If you wish to restart, see [kubernetes/setup/configuration](../setup/configuration/README.md)
