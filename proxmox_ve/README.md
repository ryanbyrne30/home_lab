# [Proxmox Virtual Environment](https://www.proxmox.com/en/proxmox-virtual-environment/overview)

Proxmox Virtual Environment is a complete, open-source server management platform for enterprise virtualization. It tightly integrates the KVM hypervisor and Linux Containers (LXC), software-defined storage and networking functionality, on a single platform. With the integrated web-based user interface you can manage VMs and containers, high availability for clusters, or the integrated disaster recovery tools with ease.

## [Download](https://www.proxmox.com/en/downloads/proxmox-virtual-environment)

## [Documentation](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/documentation)

## Good Practice

### Creating Templates

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

### Creating Template Clones

```bash
# reset ssh host keys
sudo dpkg-reconfigure openssh-server
```
