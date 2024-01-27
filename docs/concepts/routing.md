# Routing

## Tools

- [VyOS](../tools/vyos/README.md) - Open source virtualized router

## Good to Know

## Virtual Local Area Network (VLAN)

VLANs are virtualized, isolated networks. VLANs are great to setup when you want to isolate communication of networks.

For example, you can create a network specific for an accounting department and marketing department. The devices on the accounting network and the devices on the marketing network will not be able to communicate with each other, unless a method of translation was created between them (see [NAT](#network-address-translation-nat)).

A VLAN can be created by utilizing the [IEEE 802.1Q (Dot1q)](https://en.wikipedia.org/wiki/IEEE_802.1Q) standard. This standard allows for network packets to be tagged and therefore the ability to isolate network packets specific to VLANs. Tagged ports (**trunk ports**) allow tagged packets to flow along them. Trunk ports often connect to trunk ports on other devices like a switch. This allows a VLAN to span across multiple switches by connecting switches with trunk ports. Untagged ports (**access ports**) only accept traffic for a specific VLAN. Generally speaking, trunk ports connect switches while access ports connect end devices.

### Network Address Translation (NAT)

Mapping an IP address to another. This is useful for connecting traffic from one network to another, such as [VLANs](#virtual-local-area-network-vlan). NATs are created and managed by a router like [VyOS](./vyos.md).

#### SNAT (Source NAT)

SNATs allow for traffic origination from within a router's network to access another connected network through IP masquerading.

Example use case:

Your home internet gateway is located at `192.168.0.1/24` and you setup a VLAN with a gateway at `192.168.100.1/24`. In order to allow devices on the VLAN to access the internet using your internet gateway, you would create an SNAT from `192.168.100.0/24` to `192.168.0.1/24`. If a device from within the VLAN wishes to access the internet, its traffic would be masqueraded to an IP address that exists on the network `192.168.0.0/24`. The device would also have access to devices on both the VLAN and default network as well (unless a firewall says otherwise). Devices on the default network `192.168.0.0/24` would not have access to the devices on the VLAN.

#### DNAT (Destination NAT)

DNATs allow for traffic originating from outside a network the ability to enter a network. DNATs are often referred to as port forwarding since traffic originating from outside a network will need to access the internal network through a specific port that is forwarded to an internal IP address.

Example use case:

You have a router that sits between your default network at `192.168.0.60/24` and a VLAN at `192.168.100.1/24`. Your web server exists in the VLAN network at `192.168.100.5`. In order to allow traffic to hit your web server you need to open up port `80` on the rouer and forward traffic from that port to your server at `192.168.100.5`. Clients will then be able to view your web server by hitting your router at the specified port `192.168.0.60:80`.
