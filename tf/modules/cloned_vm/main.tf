terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.42.1"
    }
  }
}

provider "proxmox" {
  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs#api-token-authentication
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure  = true

  ssh {
    agent    = true 
  }
}

resource "proxmox_virtual_environment_vm" "cloned_vm" {
  depends_on = [ var.vm_depends_on ]
  name        = var.name
  description = var.description
  tags        = concat(["terraform"], var.tags)

  node_name = var.node_name
  vm_id     = var.vm_id

  agent {
    enabled = var.use_qemu_agent 
  }

  clone {
    vm_id = var.template_id 
    full = true
  }

  cpu {
    cores = var.cpus
  }

  memory {
    dedicated = var.memory
  }

  disk {
    discard = "on"
    size = var.disk_size 
    interface = "scsi0"
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      discard = "on"
      interface = "scsi0"
      datastore_id = disk.value["datastore_id"]
      size = disk.value["size"]
    }
  }

  initialization {
    # keeping default connection so Terraform can manage it 
    ip_config {
      ipv4 {
        address = "dhcp"
        gateway = "192.168.0.1"
      }
    }
    dynamic "ip_config" {
      # one ip_config for each network device
      for_each = var.network_devices
      content {
        ipv4 {
          address = ip_config.value["address"]
          gateway = ip_config.value["gateway"]
        }
      }
    }
  }

  # keeping default connection so Terraform can manage it 
  network_device {
    bridge = "vmbr0"
    firewall = true
  }

  dynamic "network_device" {
    # one network_device for each network device
    for_each = var.network_devices
    content {
      bridge = network_device.value["bridge"] 
      vlan_id = network_device.value["vlan_id"]
    }
  }
}
