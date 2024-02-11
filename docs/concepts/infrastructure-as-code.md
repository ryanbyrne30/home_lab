# Infrastructure as Code

Book: Infrastructure as Code - Kief Morris

## Foundations

### Four Key Metrics

1. **Delivery lead time**: time to implement, test and deliver changes to production
2. **Deployment frequency**: how often deploy changes to production
3. **Change fail perfectage**: percentage of changes that need to be rolled back
4. **Mean time to restore**: how long it takes to restore service when unplanned outage or impairment

### Three Core Practices

- Define everything as code
  - reusability
  - consistency
  - transparency
- Continuosly test and deliver all work in progress
  - test as you work
  - build quality in rahter than trying to test quality in
- Build small, simple pieces that can be changed independently

## Principles of Cloud Age Infrastructure

### Assume systems are unreliable

- need to patch, upgrade systems and periodically take them offline

### Make everything reproducible

- replicate systems across regions
- test environments should be similar to prod

### Pitfall: Snowflake system

- happens naturally over time if not kept on top of
  - can start by making a change to one environment/system and not all others
  - manual changes to IAC system can cause snowflake systems
- when you are not confident you can safely change or upgrade a system

### Create disposable things

- should be able to gracefully add, remove, start, stop and change parts of the system
- operational flexibiliy, availability and scalability

### Minimize variation

- fewer pieces -> easier to manage
- keep versions the same or similar
- consistent OS's
- be weary of configuration drift

### Ensure any process can be repeated

- make scripts

## Infrastructure Platforms

### Parts of an infrastructure system

- applications
  - services
- application runtimes
  - containers, serverless environments, operating systems, etc
- infrastructure platform
  - compute, storage, networking primitives

### Infrastructure resources

#### Compute resources

- virtual machines
- physical servers
- containers
- application hosting clusters
  - ECS
  - EKS
  - GKE
  - AKS
- FaaS serverless code runtimes
  - Lambda functions
  - edge runtimes

#### Storage resources

- block storage (virtual disk volumes)
  - EBS
- object storage
  - S3
- networked filesystems (shared network volumes)
  - NFS
- structured data storage
  - database as a service
  - SQL db
- secrets management

#### Network resources

- software defined networking (SDN)
- network address blocks
  - AWS VPC
  - subnets/VLANs
- names (DNS entries)
- routes
- gateways
- load balancing rules
- proxies
- API gateways
- VPNs
- direct connection
- network access rules (firewalls)
- asynchronous messaging
- cache
- service mesh

## Core Practice: Define Everything as Code

### Manage code in a version control system

### Infrastructure coding languages

- Domain-Specific Infrastructure Languages (DSL)
- Puppet
- Chef
- Ansible
- Saltstack
- Terraform
- CloudFormation
- Pulumi
- AWS CDK

### Implementation principles for defining infrastructure as code

- separate imperative and declarative code
- treat infrastructure like real code
- code should be idempotent

## Building Infrastructure Stacks as Code

### Patterns and antipatterns for structuring stacks

#### Antipattern: Monolithic stack

- single stack managing all resources

#### Pattern: Application Group Stack

- infrastructure for multiple related services

#### Pattern: Service Stack

- infrastructure for each deployable application component

#### Pattern: Micro Stack

- divides infrastructure for a single service across multiple stacks

## Building Environments with Stacks

### Environments

- Delivery environments
- Multiple production environments
  - fault tolerance
  - scalability
  - segregation

### Patterns for building environments

#### Antipattern: Multiple-environment stack

- defines and manages infrastructure for multiple enviornments as a single stack
- ex. three environments (dev, test, prod) are configured via a single stack that includes code for all three environments

#### Antipattern: Copy-Paste environments

- separate stack source code for each infrastructure stack instance
- ex. three environments (dev, test, prod) each has its own infrastructure project. Changes made in one project need to be copied and pasted to other projects

#### Pattern: Reusable stack

- infrastructure source code project that can be used to create multiple instances of a stack

## Configuring Stack Instances

### Patterns for configuring stacks

#### Antipattern: Manual Stack Parameters

- supplying parameters via command line

#### Pattern: Stack Environment Variables

- setting parameters via environment variables

#### Pattern: Scripted Parameters

- hard coding parameters in scripts

#### Pattern: Stack Configuration Files

- configuration files that define parameter values

#### Pattern: Wrapper Stack

- infratstructure stack project for each instance as a wrapper to import stack code component

#### Pattern: Pipeline Stack Parameters

- define values for each instance in the configuration of a delivery pipeline

#### Pattern: Stack Parameter Registry

- manages parameter values in a central location
- useful for larger organizations and teams
- tools
  - Chef Infra Server
  - PuppetDB
  - Ansible Tower
  - Salt Mine
  - Zookeeper
  - etcd
  - Consul^2
  - doozerd
