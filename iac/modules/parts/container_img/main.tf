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

resource "proxmox_virtual_environment_download_file" "image" {
  content_type = var.content_type
  datastore_id = var.datastore_id
  node_name    = var.node_name
  url = var.url
  file_name    = var.file_name
}
