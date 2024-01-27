# [WireGuard](https://www.wireguard.com)

[Official docs](https://www.wireguard.com/quickstart/)
[Unofficial docs](https://github.com/pirate/wireguard-docs)
[Arch Wiki](https://wiki.archlinux.org/title/WireGuard#Specific_use-case:_VPN_server)

WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache. It intends to be considerably more performant than OpenVPN. WireGuard is designed as a general purpose VPN for running on embedded interfaces and super computers alike, fit for many different circumstances. Initially released for the Linux kernel, it is now cross-platform (Windows, macOS, BSD, iOS, Android) and widely deployable. It is currently under heavy development, but already it might be regarded as the most secure, easiest to use, and simplest VPN solution in the industry.

## Home Lab Setup

### [Installation](https://www.wireguard.com/install/)

Installing WireGuard on the server and clients are the same process. On Ubuntu it is as simple as running `sudo apt install wireguard`. Checkout the [installation docs](https://www.wireguard.com/install/) for other installation methods.

### [Key Generation](https://github.com/pirate/wireguard-docs#key-generation)

For each client/server you will need a separate public/private key pair. These keypairs can be generated as follows. If these keypairs should be stored, they should be stored in an encrypted manner.

```bash
# generate private key
wg genkey > example.key

# generate public key
wg pubkey < example.key > example.key.pub
```

### Configuration

[source - Arch Wiki](https://wiki.archlinux.org/title/WireGuard#Specific_use-case:_VPN_server)

Configure WireGuard by creating a configuration file at `/etc/wireguard/wg0.conf`.

**server**

```conf
# /etc/wireguard/wg0.conf

[Interface]
Address = 10.0.0.1/24 # CIDR address of the server on the WG network
ListenPort = 51820
PrivateKey = SERVER_PRIVATE_KEY # Private key of the server created in previous step

# substitute eth0 in the following lines to match the Internet-facing interface
# if the server is behind a router and receives traffic via NAT, these iptables rules are not needed
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
# foo
PublicKey = PEER_FOO_PUBLIC_KEY # Public key of the client
PresharedKey = PRE-SHARED_KEY   # Optional pre-shared key (should be the same on both client and server)
AllowedIPs = 10.0.0.2/32    # IP address of the client on the WG network

[Peer]
# bar
PublicKey = PEER_BAR_PUBLIC_KEY
PresharedKey = PRE-SHARED_KEY
AllowedIPs = 10.0.0.3/32
```

**client**

```conf
# /etc/wireguard/wg0.conf

[Interface]
Address = 10.0.0.2/32             # IP of the client in the WG network
PrivateKey = PEER_FOO_PRIVATE_KEY # Client private key created in previous step
DNS = 10.0.0.1                    # IP of server in WG network

[Peer]
PublicKey = SERVER_PUBLICKEY      # Public key of the server
PresharedKey = PRE-SHARED_KEY     # Optional pre-shared key (should be same on both client and server)
Endpoint = my.ddns.example.com:51820  # Public DNS or IP of WG server
AllowedIPs = 0.0.0.0/0, ::/0      # IP addresses accessible by client on WG network
```

#### Allowing WG Access To LAN

[source](https://unix.stackexchange.com/questions/638889/make-local-resources-available-when-connected-to-wireguard-vpn)

On the **server** in `/etc/wireguard/wg0.conf` add the following lines:

```conf
[Interface]
...
# IP forwarding
PreUp = sysctl -w net.ipv4.ip_forward=1
# IP masquerading
PreUp = iptables -t mangle -A PREROUTING -i wg0 -j MARK --set-mark 0x30
PreUp = iptables -t nat -A POSTROUTING ! -o wg0 -m mark --mark 0x30 -j MASQUERADE
```

On the **client** in `/etc/wireguard/wg0.conf`, add the IP address range of the LAN you wish to have access to on the server

```conf
[Peer]
...
AllowedIPs = 192.168.0.0/24 #, 0.0.0.0/24, ::/0
```

### [Running WireGuard](https://github.com/pirate/wireguard-docs#start--stop)

Running WireGuard on a client and server is the same process using `wg-quick up|down IFACE` which will look for the associated configuration file in `/etc/wireguard/IFACE.conf`.

Start WireGuard
`wg-quick up wg0`

Stop WireGuard
`wg-quick down wg0`

## Troubleshooting

### resolvconf command not found

[source](https://superuser.com/questions/1500691/usr-bin-wg-quick-line-31-resolvconf-command-not-found-wireguard-debian)

```bash
ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf
```
