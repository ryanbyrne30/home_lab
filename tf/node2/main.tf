terraform {
    # source (https://registry.terraform.io/providers/bpg/proxmox/latest/docs)

    backend "s3" {
        # set AWS access key: export AWS_ACCESS_KEY_ID=mykey
        # set AWS secret access key: export AWS_SECRET_ACCESS_KEY=AAAA...

        bucket = "ryanbyrne30-homelab-config" 
        key = "terraform/node2.tfstate"
        region = "us-west-1" 
    }
}


module "k8s_node" {
  source = "../modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab2"
  name = "k8s-node"
  description = "Hosts Rancher dashboard to control public and internal clusters"
  vm_id = 5001
  template_id = 100

  cpus = 2 
  memory = 4096 
  disk_size = 100 
}

resource "local_file" "k8s_ansible_inventory" {
  filename = var.inventory_file 
  content = <<EOF
[k8s-node]
${join("\n", module.k8s_node.ip)} hostname=k8s-node disk_size=100
EOF
}

# module "ubuntu_image" {
#   source = "../modules/container_img"

#   proxmox_endpoint = var.proxmox_endpoint
#   proxmox_username = var.proxmox_username
#   proxmox_password = var.proxmox_password

#   content_type = "vztmpl"
#   datastore_id = "local"
#   node_name = "homelab2"
#   url = "http://download.proxmox.com/images/system/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
#   file_name = "ubuntu-22.04--dynamic.tar.zst"
# }

# module "log_server" {
#   source = "../modules/container"

#   proxmox_endpoint = var.proxmox_endpoint
#   proxmox_username = var.proxmox_username
#   proxmox_password = var.proxmox_password

#   node_name = "homelab2"
#   name = "log-server"
#   description = "OpenSearch logging aggregator"
#   vm_id = 5005

#   hostname = "log-server"
#   ssh_keys = [ var.ssh_key ]
#   root_password = var.admin_password

#   image_id = module.ubuntu_image.id
#   image_type = "ubuntu"

#   mounts = [{
#     volume = "bulk-ext4",
#     size = "10G",
#     path = "/mnt/logs"
#   }]

#   disk_store = "local-lvm"
#   disk_size = 8

#   cpu_cores = 1 
#   memory = 2048 
# }


# module "agent_server" {
#   source = "../modules/container"

#   proxmox_endpoint = var.proxmox_endpoint
#   proxmox_username = var.proxmox_username
#   proxmox_password = var.proxmox_password

#   node_name = "homelab2"
#   name = "agent-server"
#   description = "OpenSearch logging agent"
#   vm_id = 5006

#   hostname = "agent-server"
#   ssh_keys = [ var.ssh_key ]
#   root_password = var.admin_password

#   image_id = module.ubuntu_image.id
#   image_type = "ubuntu"

#   disk_store = "local-lvm"
#   disk_size = 8

#   cpu_cores = 1 
#   memory = 512 
# }

# resource "local_file" "ansible_inventory" {
#   filename = var.inventory_file 
#   content = <<EOF
# [log-server]
# #DHCP 

# [agent]
# #DHCP
# EOF
# }