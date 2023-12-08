# K8s Certificates

Using `kubeadm` to install K8s automatically install certificates for the cluster. These certificates are typically stored in `/etc/kubernetes/pki`. User account certificates are placed in the `/etc/kubernetes` directory.

Certificates typically last a year before expiration. You can check the expiration of your certs using

```bash
kubeadm certs check-expiration
```

A more secure approach would be to store the certificates off the server.

For more information on certificates and configuring certificates manually, check the [official docs](https://kubernetes.io/docs/setup/best-practices/certificates/).
