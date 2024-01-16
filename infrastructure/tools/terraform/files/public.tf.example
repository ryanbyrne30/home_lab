module "vlan1" {
  source = "./modules/vlan"
    
  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password

  node_name = "homelab"
  vlan_id = 1 
  comment = "Public VLAN"
  ipv4_cidr = "192.168.1.0/24"
}

module "public_gateway" {
  vm_depends_on = [ module.vlan1 ]
  source = "./modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "public-gateway"
  description = "Public VyOS gateway"
  vm_id = 5000
  template_id = 102

  network_devices = [{
    address = "192.168.1.1/24"
    vlan_id = 1
  }]
}

module "public_proxy" {
  vm_depends_on = [ module.public_gateway ]
  source = "./modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "public-proxy"
  description = "Public reverse proxy into services on public VLAN"
  vm_id = 5001
  template_id = 100 

  network_devices = [{
    address = "192.168.1.2/24"
    gateway = "192.168.1.1"
    vlan_id = 1
  }]
}

module "public_bastion" {
  vm_depends_on = [ module.public_gateway ]
  source = "./modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "public-bastion"
  vm_id = 5002
  template_id = 100

  network_devices = [{
    address = "192.168.1.3/24"
    gateway = "192.168.1.1"
    vlan_id = 1
  }]
}

module "public_node1" {
  vm_depends_on = [ module.public_gateway ]
  source = "./modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "public-node1"
  vm_id = 5003
  template_id = 100

  cpus = 2
  memory = 4096
  disk_size = 100

  network_devices = [{
    address = "192.168.1.4/24"
    gateway = "192.168.1.1"
    vlan_id = 1
  }]
}

resource "local_file" "public_ansible_inventory" {
  filename = "output/public/inventory.ini"
  content = <<EOF
[gateways]
${join("\n", module.public_gateway.ip)}

[proxies]
${join("\n", module.public_proxy.ip)} hostname=proxy

[bastions]
${join("\n", module.public_bastion.ip)} hostname=bastion

[nodes]
${join("\n", module.public_node1.ip)} hostname=public_node1 disk_size=100

EOF
}