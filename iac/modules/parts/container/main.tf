terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.44.0"
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

resource "proxmox_virtual_environment_container" "container" {
  depends_on = [ var.vm_depends_on ]
  description = var.description
  tags        = concat(["terraform"], var.tags)

  node_name = var.node_name
  vm_id     = var.vm_id
  started = true

  initialization {
    hostname = var.hostname 

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

    user_account {
      keys = var.ssh_keys
      password = var.root_password 
    }
  }

  cpu {
    cores = var.cpu_cores
    units = var.cpu_units
  }

  memory {
    dedicated = var.memory 
    swap = var.swap
  }

  disk {
    datastore_id = var.disk_store
    size = var.disk_size
  }

  dynamic "network_interface" {
    # one network_device for each network device
    for_each = var.network_devices
    content {
      name = network_interface.value["name"]
      bridge = network_interface.value["bridge"] 
      vlan_id = network_interface.value["vlan_id"]
      firewall = true
    }
  }

  operating_system {
    template_file_id = var.image_id
    type             = var.image_type
  }

  dynamic "mount_point" {
    # one network_device for each network device
    for_each = var.mounts
    content {
      volume = mount_point.value["volume"] 
      size = mount_point.value["size"]
      path = mount_point.value["path"]
    }
  }
}
