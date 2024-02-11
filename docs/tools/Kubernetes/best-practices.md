# Best Practices

- [Configuration](#configuration)
  - [ConfigMaps](#configmaps)
  - [Helm Charts](#helm-charts)
- [Developer Workflows](#developer-workflows)
  - [Setting up a shared cluster for multiple developers](#setting-up-a-shared-cluster-for-multiple-developers)
    - [Managing namespaces](#managing-namespaces)
- [Monitoring and Logging](#monitoring-and-logging)
  - [Metrics](#metrics)
    - [cAdvisor](#cadvisor)
    - [Metrics server](#metrics-server)
    - [kube-state-metrics](#kube-state-metrics)
  - [What to Monitor?](#what-to-monitor)
    - [Best practices](#best-practices-1)
    - [Tools](#tools)
  - [Logging](#logging)
    - [What to log?](#what-to-log)
    - [Tools](#tools-1)
    - [Best practices](#best-practices-2)
- [Configuration, Secrets and RBAC](#configuration-secrets-and-rbac)
  - [ConfigMaps](#configmaps-1)
  - [Secrets](#secrets)
  - [Best Practices for ConfigMaps and Secrets](#best-practices-for-configmaps-and-secrets)
  - [RBAC](#rbac)
    - [Best Practices](#best-practices-3)
- [Resource Management](#resource-management)
  - [Namespaces](#namespaces)
  - [Application Scaling](#application-scaling)
  - [Best Practices](#best-practices-4)
- [Networking, Network Security and Service Mesh](#networking-network-security-and-service-mesh)
  - [Networking Principles](#networking-principles)
  - [Network Plugin-Ins](#network-plugin-ins)
  - [Services](#services)
    - [Best Practices](#best-practices-5)
  - [Network Security Policy](#network-security-policy)
    - [Network Policy Best Practices](#network-policy-best-practices)
- [Service Meshes](#service-meshes)
  - [Service Mesh Best Practices](#service-mesh-best-practices)
- [Pod and Container Security](#pod-and-container-security)
  - [PodSecurityPolicy API](#podsecuritypolicy-api)
  - [Workload Isolation and RuntimeClass](#workload-isolation-and-runtimeclass)
    - [Workload Isolation and RuntimeClass Best Practices](#workload-isolation-and-runtimeclass-best-practices)
  - [Other Security Considerations](#other-security-considerations)
- [Managing State and Stateful Applications](#managing-state-and-stateful-applications)
  - [Volumes and Volume Mounts](#volumes-and-volume-mounts)
    - [Volumes Best Practices](#volumes-best-practices)
  - [Persisting Data](#persisting-data)
    - [Storage Classes](#storage-classes)
    - [Storage Best Practices](#storage-best-practices)
- [Admission Control and Authorization](#admission-control-and-authorization)

Book: Kubernetes Best Practices - Brendan Burns

## Configuration

### ConfigMaps

- updating ConfigMap values does not trigger a pod/container to update its values
  - only when a pod/container is restarted do the changes take place
- it is better practice to version the ConfigMap in the configuration file
  - that way when a change to the ConfigMap version occurs, it will trigger the container to update as well

### Helm Charts

- makes it easy to replicate clusters to different environments
- easier configuration for implementing

## Developer Workflows

- two main ways
  - one cluster per developer
    - no overlap for developers when making changes
    - no risk of a developer taking too many resources
  - one cluster for all devs
    - less resources
    - developers can hog resources from other devs

### Setting up a shared cluster for multiple developers

- create a certificate for user to authenticate with namespace
- create a separate namespace for each dev
- secure namespace by granting access to the namespace to the user via RoleBindings
- limit the amount of resources consumed by the namespace with ResourceQuota

#### Managing namespaces

- setup dev namespaces with a TTL in order to enforce garbage collection
- this works by deleting the namespace after a period of time which removes all developer resources (garbage collection)

## Monitoring and Logging

### Metrics

#### cAdvisor

- collections memory and CPU metrics through the Linux control group (cgroup) tree

#### Metrics server

- two uses
  - canonical implementation
    - resource metrics for Horizontal Pod Autoscaler (HPA) and Verical Pod Autoscaler (VPA)
  - Metrics API
    - allow monitoring systems to collect abitrary metrics

#### kube-state-metrics

- add-on that monitors the object stored in K8s
- example
  - Pods
    - How many pods are deployed in the cluster?
    - How many in pending state?
  - Nodes
    - What's the status of the worker nodes

### What to Monitor?

- nodes
  - CPU utilization
  - memory utilization
  - network utilization
  - disk utilization
- cluster components
  - etcd latency
- cluster add-ons
  - cluster autoscaler
  - ingress controller
- application
  - container memory utilization and saturation
  - container CPU utilization
  - container network utilization and error rate
  - application framework-specific metrics

#### Best practices

- use black box monitoring to inspect the system for symptoms and not predictions of symptoms
- use white box monitoring to inspect the system and its internals
- use time series based metrics

#### Tools

- Prometheus
- InfluxDB
- Datadog
- Sysdig

### Logging

#### What to log?

- node logs
- K8s control-plane logs
  - API server
  - controller manager
  - scheduler
- K8s audit logs
- application container logs

#### Tools

- Elastic Stack
- Datadog
- Sumo Logic
- Sysdig

#### Best practices

- use logging in combination with metrics
- be cautious of storing logs for more than 30-45 days (if needed use long term storage)
- limit usage of log forwarders in a sidecar pattern as they use a lot more resources
  - use DaemonSet for the log forwarder and sending logs to STDOUT

## Configuration, Secrets and RBAC

### ConfigMaps

- can be injected into pods via a volume mount or environment variables

### Secrets

- three types

  - generic
    - key-value pairs
  - docker-registry
    - authentication details for pulling images
  - tls
    - public/private TLS keys

- secrets are stored by default in plaintext
  - encryption at rest can be configured in etcd environment

### Best Practices for ConfigMaps and Secrets

- for dynamic changes to pods without redeploying, mount ConfigMaps and Secrets as a volume mount
- storing secrets in a secrets repository will allow better security than what is offered by K8s natively
- use CI/CD to pull secrets from secret repo during release

### RBAC

- Subjects
- Rules
- Roles
- RoleBindings

#### Best Practices

- rarely do applications running in K8s need RBAC
  - only if they are interacting with the K8s API
- use an OpenID Connect service to enable identity management
  - map user groups to roles that have least privileges
- use Just In Time (JIT) access systems
- specific service accounts should be used for CI/CD tools that deploy K8s clusters
- Helm uses the default service account Tiller deployed to `kube-system`
  - best to deploy Tiller into each namespace with a service account specifically for Tiller that is scoped for that namespace
  - in the tools that calls Helm install/upgrade in CI/CD, initialize the Helm client with the service account and specific namespace for the deployment
  - service account name can be the same for each namespace, but namespaces should be specific
- limit any applications that require `watch` and `list` on the Secrets API

## Resource Management

- set resource limits on pods (vertical scalability)

### Namespaces

- base namespaces
  - kube-system
    - K8s internal components are deployed here (`coredns`, `kube-proxy`, `metrics-server`)
  - default
    - default namespace
  - kube-public
    - used for anonymous and unauthenticated content
    - reserved for system usage
- setup `ResourceQuota`s for namespaces
  - quotas can be set for
    - compute resources
      - cpu: sum of CPU requests cannot exceed this amount
      - limits.cpu: sum of CPU limits cannot exceed this amount
      - memory: sum of memory requests cannot exceed this amount
    - storage resources
      - requests.storage: sum of storage requests
      - persistentvolumeclaims: total number of PVCs that can exist in this namespace
      - storageclass.request: volume claims assocated with the specified sotrage-class cannot exceed this value
      - storageclass.pvc: total number of PVCs that can exist in the namespace
    - object count quotas
      - count/pvc
      - count/services
      - count/deployments
      - count/replicasets
- `LimitRange`: default limits for pods created in namespace

### Application Scaling

- Horizontal Pod Autoscaler (HPA)
  - customize how many and when replica set should increase or decrease number of pods
  - great with stateless applications
- Vertical Pod Autoscaler (VPA)
  - scales resource availability for pods
  - great for stateful applications (MySQL databases)

### Best Practices

- use pod anti-affinity to spread workloads across multiple AZs to ensure HA
- use taints for nodes with specialized hardware to ensure only specific workloads are created on those nodes
- use nodeSelectors for pods that require specific resources on certain nodes
- ensure you set resource limits on all pods
- use ResourceQuotas to enuser multiple teams/applications are alotted their fair share of resources
- use LimitRange for setting default limits on pods
- start with manual cluster scaling before moving to autoscaling
- use HPA for workloads that are vairable and have unexpected spikes in usage

## Networking, Network Security and Service Mesh

### Networking Principles

- container-to-container in the same pod
  - allows for `localhost` communication (ex. http://localhost:3000)
- pod-to-pod communication
  - no NAT involved -> true IPs of pods
  - how this is handled depends on network plugin used
- server-to-pod communication
  - two main methods
    - iptables
    - IP Virtual Server (IPVS)

### Network Plugin-Ins

- kubenet
  - out of the box with K8s
  - Linux bridge `cbr0`
- CNI
  - customizable and can provide more features specific to infrastructure/tooling

### Services

- ClusterIP
  - default
  - service is assigned an IP from a disignated service CIDR range
  - declares DNS name for service
    - `<service_name>.<namespace_name>.svc.cluster.local`
- NodePort
  - assigns port on node (30000-32767) to service
- ExternalName
  - rarely used
  - passes cluster-durable DNS names to external DNS named services
- LoadBalancer
  - enabled automation with cloud providers (AWS ELB)
- Ingress and Ingress Controllers
  - allows for host-based routing
  - defines TLS certificate via secrets (if needed)

#### Best Practices

- limit applications with ingresses (exposed services)
- when serving mostly APIs externally, evaluate the use of API tailored ingress controllers (like Kong or Ambassador) as these may be more beneficial

### Network Security Policy

- akin to East-West traffic firewall
- policy specification includes `podSelector` (required), `ingress`, `egress` and `policyType` fields
- namespaced objects

Default deny rule

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

Web layer network policy

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: webaccess
spec:
  podSelector:
    matchLabels:
      tier: "web"
  policyTypes:
    - Ingress
  ingress:
    - {}
```

#### Network Policy Best Practices

- start off slow and focus on traffic ingress to pods
- ensure network plug-in used supports NetworkPolicy API (Calico, Cilium, Kube-router, Romana, Weave Net)
- if "default-deny" policy is expected create the following NetworkPolicy for each namespace in order to ensure that this policy is kept even if another namespaces policy is accidentally deleted

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

- if pods need to be accessed by the internet, use a label to explicitly apply a network policy that allows ingress (note that traffic originates from the internet, but the pod will receive the IP of the service/ingress/external resources)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: internet-access
spec:
  podSelector:
    matchLabels:
      allow-internet: "true"
  policyTypes:
    - Ingress
  ingress:
    - {}
```

- create a test bed namespace with fewer restrictive policies to allow time to investigate the correct traffic patterns needed

## Service Meshes

- allows control over how services are connected and secured with a dedicated data plane and control plane
- common capabilities of control planes
  - load balancing
  - service discovery
  - observability
  - security
  - resiliency, health and failure-prevention capabailities (circuit breaker, retires, deadlines, etc)

### Service Mesh Best Practices

- rate the importance of key features service meshes offer
  - is it worth the human and resource overhead
  - can the capabilities be offered with another service (CNI)

## Pod and Container Security

### PodSecurityPolicy API

- cluster-wide resource creates singe place to define and manage all security-sensitive fields found in pod specs
- generally an opt-in feature since it is difficult to configure
- probably not needed as RBAC should take care of most security footprint

### Workload Isolation and RuntimeClass

- RuntimeClass allows specifying a supported container runtime for a pod
  - can specify what time of sandboxing/isolation for the pod based on the runtime
  - types
    - CRI containerd
      - An API facade for container runtimes with an emphasis on simplicity, robustness, and portability.
    - cri-o
      - A purpose-built, lightweight Open Container Initiative (OCI)-based implementation of a container runtime for Kubernetes.
    - Firecracker
      - Built on top of the Kernel-based Virtual Machine (KVM), this virtualization technology allows you to launch microVMs in nonvirtualized environments very quickly using the security and isolation of traditional VMs.
    - gVisor
      - An OCI-compatible sandbox runtime that runs containers with a new user-space kernel, which provides a low overhead, secure, isolated container runtime.
    - Kata Containers
      - A community that’s building a secure container runtime that provides VM-like security and isolation by running lightweight VMs that feel and operate like containers.

#### Workload Isolation and RuntimeClass Best Practices

- Configuring RuntimeClass will complicate operational environment (portability of pods may not be great)
  - recommend separate clusters each with a single runtime
- workload isolatation does not imply secure multitenancy
  - isolated workloads can still be modified by bad actor via K8s API
- tooling across different runtimes is inconsistent

### Other Security Considerations

- Admissino Controllers
- Intrusion and Anomaly Detection Tooling (Falco)

## Managing State and Stateful Applications

### Volumes and Volume Mounts

#### Volumes Best Practices

- limit the use of volumes to pods requiring multiple containers that need to share data (adapter/ambassador patters)
  - use `emptyDir` for those sharing patterns
- use `hostDir` when access to the data is required by node-based agents or services
- identify services that write critical application logs to local disk and change those to `stdout` or `stderr` and use a real log aggregator to stream logs

### Persisting Data

#### Storage Classes

- useful for defining volume plug-in to use and specific mount options and parameters that all PersistentVolumes of that class will use
  - do not have to manually create PersistentVolume if using StorageClass in PVC

#### Storage Best Practices

- if possible, enable `DefaultStorageClass` admission plug-in and define a default storage class
  - many Helm charts that require PersistentVolumes default to default storage class for the chart which allows the application to be installed without much modification
- use affinity to keep storage and pods close together when working with multiple AZs
- consider carefully which workloads require state to be on disk
  - can it be handled by an outside service like a database system?
  - can that data be streamed to STDOUT (logging)?
- how much effort to make application stateless (non reliant on persistent data)
- take snapshots or backups of necessary volumes (can be accomplished with CSI spec)
  - K8s does not handle redundancy of data
- verify proper life cycle of data
  - reclaim: deletes volume from storage provider when pod is deleted
  - sensitive data or data used for forensic analysis should be set to reclaim

## Admission Control and Authorization

- Admission controllers help define policies throughout a K8s cluster
  - examples
    - all containers in a pod must have resource limits
    - all ingress resources only use HTTPS
    - all ingress FQDN fall within a specific suffix
- two classes of controllers
  - standard
  - dynamic
