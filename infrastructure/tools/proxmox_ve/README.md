# [Proxmox Virtual Environment](https://www.proxmox.com/en/proxmox-virtual-environment/overview)

Proxmox Virtual Environment is a complete, open-source server management platform for enterprise virtualization. It tightly integrates the KVM hypervisor and Linux Containers (LXC), software-defined storage and networking functionality, on a single platform. With the integrated web-based user interface you can manage VMs and containers, high availability for clusters, or the integrated disaster recovery tools with ease.

## [Download](https://www.proxmox.com/en/downloads/proxmox-virtual-environment)

## [Official Documentation](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/documentation)

## Creating Templates

### Prep machine

```bash
# update and upgrade
sudo apt update && sudo apt upgrade

# remove ssh host keys (need to be regenerated when cloned)
sudo rm /etc/ssh/ssh_host_*

# remove machine id
sudo truncate -s 0 /etc/machine-id

# relink machine id if detached
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id

# clean cache
sudo apt clean && sudo apt autoremove
```

Then shut down the machine

### Post shutdown

- Remove the ISO from Hardware
- Add CloudInit Drive to Hardware
- Convert to template

### Creating Template Clones

```bash
# reset ssh host keys
sudo dpkg-reconfigure openssh-server
```

## [QEMU Guest Agent](https://pve.proxmox.com/wiki/Qemu-guest-agent)

Allows Proxmox to communicate with guest VMs and containers. Useful when running Terraform and you want info from the created resource.

**On the client:**

```bash
sudo apt-get install qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo reboot
```

**On the Proxmox dashboard:**

Go to "Options" -> "QEMU Guest Agent". Make sure "Use QEMU Guest Agent" and "Run guest-trim" are on.

**Testing QEMU Guest Agent installation**

On the Proxmox server run:

```bash
qm agent <VM_ID> ping
```

This should return without an error if installed properly.
