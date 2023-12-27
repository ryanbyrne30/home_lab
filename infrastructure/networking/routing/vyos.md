# [VyOS](https://vyos.io/)

[Documentation](https://docs.vyos.io/en/latest/index.html)

VyOS is an open source network operating system based on Debian GNU/Linux.

VyOS provides a free routing platform that competes directly with other commercially available solutions from well known network providers. Because VyOS runs on standard amd64, i586 and ARM systems, it is able to be used as a router and firewall platform for cloud deployments.

We use multiple live versions of our manual, hosted thankfully by https://readthedocs.org. We will provide one version of the manual for every VyOS major version starting with VyOS 1.2 which will receive Long-term support (LTS).

The manual version is selected/specified by it’s Git branch name. You can switch between versions of the documentation by selecting the appropriate branch on the bottom left corner.

VyOS CLI syntax may change between major (and sometimes minor) versions. Please always refer to the documentation matching your current, running installation. If a change in the CLI is required, VyOS will ship a so called migration script which will take care of adjusting the syntax. No action needs to be taken by you.

## Setting Up In Your Home Lab

### Overview

VyOS can be downloaded as an ISO and ran in a VM to serve as a virtualized router. This enables the ability to communicate between different networks like VLANs.

### [Download](https://vyos.net/get/)

VyOS can be downloaded from the VyOS [downloads page](https://vyos.net/get/). There are several options, but the nightly releases are free and open source.

### [Installation](https://docs.vyos.io/en/latest/installation/index.html)

VyOS can be installed as a VM just like any other ISO within Proxmox. See [installation guide](https://docs.vyos.io/en/latest/installation/index.html).

Once the VM is created you can install VyOS by running `install image`. The default login is `vyos/vyos`.

### [Quick Start](https://docs.vyos.io/en/latest/quick-start.html)

## Configuration

### NAT

#### SNAT

[source](https://docs.vyos.io/en/latest/quick-start.html#nat)

Create a NAT source rule (in this case named `100`) that masquerades traffic from within the network to the IP range `192.168.0.0/24` via the network device `eth0`.

```bash
set nat source rule 100 outbound-interface name 'eth0'
set nat source rule 100 source address '192.168.0.0/24'
set nat source rule 100 translation address masquerade
```

#### DNAT

[source](https://docs.vyos.io/en/latest/configuration/nat/nat44.html#id4)

Create a NAT destination rule (called `10`) that forwards HTTP traffic from port `3389` on the router from `eth0` to port `80` on the device `192.168.0.100`.

```bash
set nat destination rule 10 description 'Port Forward: HTTP to 192.168.0.100'
set nat destination rule 10 destination port '3389'
set nat destination rule 10 inbound-interface name 'eth0'
set nat destination rule 10 protocol 'tcp'
set nat destination rule 10 translation address '192.168.0.100'
set nat destination rule 10 translation port '80'
```
