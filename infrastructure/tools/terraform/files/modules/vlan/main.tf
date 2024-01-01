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

# using VLAN tag
resource "proxmox_virtual_environment_network_linux_vlan" "vlan" {
    node_name = var.node_name
    name      = "vlan${var.vlan_id}" 

    interface = var.interface
    vlan = var.vlan_id
    comment = var.comment

    address = var.ipv4_cidr
    gateway = var.ipv4_gateway
}
