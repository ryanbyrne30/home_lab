module "router" {
  source = "../../parts/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = var.node_name
  name = "router"
  description = "Router for this stack"
  vm_id = var.router_id
  template_id = var.router_template_id 

  cpus = 1
  memory = 512
  disk_size = 4

  network_devices = [
    {
        address = "10.0.0.1/24"
        bridge = "vmbr0"
    },
    {
        address = "10.0.1.1/24"
        bridge = "vmbr0"
    }
  ]
}

module "k8s_server" {
  source = "../../parts/cloned_vm"

  vm_depends_on = module.router

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = var.node_name 
  name = "k8s-server"
  description = "Hosts Rancher dashboard to control public and internal clusters"
  vm_id = var.k8s_server_id 
  template_id = var.k8s_server_template_id 

  cpus = var.k8s_server_cpus 
  memory = var.k8s_server_memory 
  disk_size = var.k8s_server_disk_size 

  network_devices = [
    {
        address = "10.0.0.2/24"
        bridge = "vmbr0"
        gateway = "10.0.0.1"
    },
    {
        address = "10.0.1.2/24"
        bridge = "vmbr0"
        gateway = "10.0.1.1"
    }
  ]
}

resource "local_file" "k8s_ansible_inventory" {
  filename = var.inventory_file 
  content = <<EOF
[router]
${join("\n", module.router.ip)} hostname=router disk_size=4


[k8s-server]
${join("\n", module.k8s_server.ip)} hostname=k8s-server disk_size=${var.k8s_server_disk_size}
EOF
}