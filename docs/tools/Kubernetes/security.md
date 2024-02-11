# K8s Security

Book: Kubernetes Security and Observability - Brendan Creane

## Deploying a Workload

### Build: Shift Left

- image scanning
- host operating system hardening
- minimize attach surface: base container images

### Deploy

- RBAC
- label taxonomies
- label governance
- admission controls
- validation

### Runtime

- network security

### Observability

- network traffic
- DNS logs
- application traffic
- K8s activity logs
- ML anomaly detection
- Security frameworks
  - MITRE
  - Threat matrix for K8s

## Infrastructure Hardening

### Host Hardening

- choice of OS
  - worth considering modern immutable Linux distro optimized for containers
    - have newer kernels
    - designed to be immutable (applications cannot modify kernel)
    - include ability to self update to newer versions
  - Flatcar Container Linux
  - Bottlerocket
- Remove nonessential processes (reduce attack vector)
- host-based firewalling

### Cluster Hardening

- secure K8s datastore
  - etcd
  - use x509 PKI and TLS
  - can use network firewall to only allow communication to etcd from K8s control nodes
  - do not store any non-K8s data to etcd
- secure K8s API server
  - can be done with x509 PKI and TLS
- encrypt K8s secrets at rest
  - by default K8s does not encrypt secrets at rest
  - rewrite all secrets after enabling to encrypt secrets (kubectl apply/update)
  - different providers for encryption
    - standard is AES-CBC with PKCS #7-based encryption
- rotate credentials frequently
  - set short lifetimes on TLS certs
  - automate rotations
  - service tokens
  - using a secrets registry can allow for credential rotation without re-encrypting secrets in K8s
- authentication and RBAC
- restrict cloud metadata API access
  - most public clouds provide a metadata API accessible locally from each host/VM which can leak credentials
  - use network policies to restrict access to bare necessities
- enable auditing
- restrict access to alpha or beta features
  - each K8s release includes alpha or beta features
  - disable if not needed
- upgrade K8s frequently
- use a managed K8s service
- CIS benchmarks
  - configuration guidance
- network security
  - determine if cluster needs to be accessed from internet
  - firewalls
  - NetworkPolicy within cluster

## Workload Deployment

### Container Image Hardnening

- only use base images from trusted sources
- minimize base images to only contain runtime dependencies for your application
- follow principle of least privilege
- pin the version of the base image in the Dockerfile (ubuntu:20.08)
  - latest or master may cause issues while scanning images in CI/CD
- compress Docker image layers into one single layer (--squash)
- use container image signing to trust the image
  - Docker Notary can be used to sign images
  - K8s can use admission controller to verify image signature

### Container Image Scanning

- should answer the following questions
  - determine OS and packages presetn in the container?
  - scan for application dependencies (understands language - Go, Python, ...)?
  - detects sensitive files? (certs & passwords)
  - false positive rate?
  - scan binaries? (.elf or .exe)
  - what data is collected?
  - where is collected data stored?
  - integrates with CI/CD system?
- FOSS tools
  - Anchore
  - Trivy
