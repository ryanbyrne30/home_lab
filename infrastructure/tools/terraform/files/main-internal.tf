
module "k8s_server" {
  source = "./modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "k8s-server"
  description = "Hosts Rancher dashboard to control public and internal clusters"
  vm_id = 1001
  template_id = 100

  cpus = 2
  memory = 4096
  disk_size = 100
}

resource "local_file" "internal_ansible_inventory" {
  filename = "output/internal/inventory.ini"
  content = <<EOF
[k8s]
${join("\n", module.k8s_server.ip)} hostname=k8s disk_size=100
EOF
}