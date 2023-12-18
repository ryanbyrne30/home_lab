# Reconfiguring K8s Cluster

[Official docs](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/)

`kubeadm` writes configuration to cluster wide components like ConfigMaps and other objects which need to be manually edited.

`kubectl edit` allows editing these configurations.

The environment variables `KUBECONFIG` and `KUBE_EDITOR` can be used to configure the location of `kubectl` consumed kuebconfig files and preferred text editor.

`KUBECONFIG=/etc/kubernetes/admin.conf`

`KUBE_EDITOR=vim`

Saving configs to cluster objects may not update automatically and will need to be **manually updated**.

## Configuration Resources

### [ClusterConfiguration](https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/#kubeadm-k8s-io-v1beta3-ClusterConfiguration)

Cluster-wide configuration for a kubeadm cluster

**type:** ConfigMap

```bash
kubectl edit cm -n kube-system kubeadm-config
```

If modifying `apiServer`, `controllerManager`, `scheduler` or `etcd`, make sure to [update the corresponding manifests](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/#reflecting-clusterconfiguration-changes-on-control-plane-nodes).

### [KubeletConfiguration](https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/#kubelet-config-k8s-io-v1beta1-KubeletConfiguration)

Configuration for the Kubelet

**type:** ConfigMap

```bash
kubectl edit cm -n kube-system kubelet-config
```

[Follow these steps](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/#reflecting-the-kubelet-changes) to apply updates after editing.

### [KubeProxyConfiguration](https://kubernetes.io/docs/reference/config-api/kube-proxy-config.v1alpha1/#kubeproxy-config-k8s-io-v1alpha1-KubeProxyConfiguration)

Configure K8s proxy server

**type:** ConfigMap

```bash
kubectl edit cm -n kube-system kube-proxy
```

[Follow these steps](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/#reflecting-the-kube-proxy-changes) to update K8s after edits have been made.

## Persisting Node object configuration

When updating nodes, configurations may change. In order to persist configurations, [follow these steps](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/#reflecting-the-kube-proxy-changes).
