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

module "vyos_gateway" {
  vm_depends_on = [ module.vlan1 ]
  source = "./modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "vyos-gateway"
  vm_id = 5000
  template_id = 102
  ip_output_file = "output/public/gateway"

  network_devices = [{
    address = "192.168.1.1/24"
    vlan_id = 1
  }]
}

module "reverse_proxy" {
  vm_depends_on = [ module.vyos_gateway ]
  source = "./modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "reverse-proxy"
  vm_id = 5001
  template_id = 107
  ip_output_file = "output/public/reverse-proxy"

  network_devices = [{
    address = "192.168.1.2/24"
    gateway = "192.168.1.1"
    vlan_id = 1
  }]
}

module "bastion" {
  vm_depends_on = [ module.vyos_gateway ]
  source = "./modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "bastion"
  vm_id = 5002
  template_id = 107
  ip_output_file = "output/public/bastion"

  network_devices = [{
    address = "192.168.1.3/24"
    gateway = "192.168.1.1"
    vlan_id = 1
  }]
}

module "k8s1" {
  vm_depends_on = [ module.vyos_gateway ]
  source = "./modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "k8s1"
  vm_id = 5003
  template_id = 107
  ip_output_file = "output/public/k8s1"

  network_devices = [{
    address = "192.168.1.4/24"
    gateway = "192.168.1.1"
    vlan_id = 1
  }]
}
