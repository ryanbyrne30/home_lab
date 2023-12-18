# Rancher Certificates

## Creating a Self-Signed CA

[Reference](https://cert-manager.io/docs/configuration/ca/https://cert-manager.io/docs/configuration/selfsigned/#bootstrapping-ca-issuers)

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: sandbox
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-selfsigned-ca
  namespace: sandbox
spec:
  isCA: true
  commonName: my-selfsigned-ca
  secretName: root-secret
  privateKey:
    algorithm: ECDSA
    size: 256
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: my-ca-issuer
  namespace: sandbox
spec:
  ca:
    secretName: root-secret
```

You can then use this CA to sign other certificates for your cluster.

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-selfsigned-cert
  namespace: sandbox
spec:
  isCA: false
  commonName: my-selfsigned-cert
  secretName: sandbox-cert
  privateKey:
    algorithm: ECDSA
    size: 256
  issuerRef:
    name: my-ca-issuer
    kind: Issuer
    group: cert-manager.io
```

## [Trust Manager](https://cert-manager.io/docs/trust/trust-manager/)

Manages TLS trust bundles for cluster so different namespaces can authorize certificates from other namespaces and communicate securely.

### Install Trust Manager

Ideally you would want a namespace dedicated to the trust manager (ie. `trust`). This way only the trust manager has access to modify the trust of the cluster. In this scenario we leave it out and it default to `cert-manager`. [Reference](https://cert-manager.io/docs/trust/trust-manager/#trust-namespace)

```bash
helm repo add jetstack https://charts.jetstack.io --force-update
helm upgrade -i -n cert-manager cert-manager jetstack/cert-manager --set installCRDs=true --wait --create-namespace
helm upgrade -i -n cert-manager trust-manager jetstack/trust-manager --wait
```

### Configure

Now that we have installed Trust Manager we have access to a custom resource `Bundle` which is a culmination of all CAs we wish to trust amongst namespaces.

```yaml
apiVersion: trust.cert-manager.io/v1alpha1
kind: Bundle
metadata:
  name: my-org.com # The bundle name will also be used for the target
spec:
  sources:
    # Include a bundle of publicly trusted certificates which can be
    # used to validate most TLS certificates on the internet, such as
    # those issued by Let's Encrypt, Google, Amazon and others.
    - useDefaultCAs: true

  target:
    # Sync the bundle to a ConfigMap called `my-org.com` in every namespace which
    # has the label "linkerd.io/inject=enabled"
    # All ConfigMaps will include a PEM-formatted bundle, here named "root-certs.pem"
    # and in this case we also request binary formatted bundles in JKS and PKCS#12 formats,
    # here named "bundle.jks" and "bundle.p12".
    configMap:
      key: "root-certs.pem"
```

For more configuration options, check [here](https://cert-manager.io/docs/trust/trust-manager/#quick-start-example).

#### Adding CA Certificates to the Trust Bundle

If you have a CA certificate you would like to add to the trust bundle (see [Creating a CA Certificate](#creating-a-self-signed-ca) above), modify the CA bundle with the secret and apply the changes.

```bash
kubectl --kubeconfig ./bin/kubeconfig.yaml apply -f - <<EOF
apiVersion: trust.cert-manager.io/v1alpha1
kind: Bundle
metadata:
  name: example-bundle
spec:
  sources:
  - useDefaultCAs: true
  # CA cert secret added here
  - secret:
      name: "trust-manager-example-ca-secret"
      key: "tls.crt"
  target:
    configMap:
      key: "trust-bundle.pem"
EOF
```

Check [here](https://cert-manager.io/docs/trust/trust-manager/#usage) for other configuration options.
