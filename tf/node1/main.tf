terraform {
    # source (https://registry.terraform.io/providers/bpg/proxmox/latest/docs)

    backend "s3" {
        # set AWS access key: export AWS_ACCESS_KEY_ID=mykey
        # set AWS secret access key: export AWS_SECRET_ACCESS_KEY=AAAA...

        bucket = "ryanbyrne30-homelab-config" 
        key = "terraform/node1.tfstate"
        region = "us-west-1" 
    }
}

module "k8s_server" {
  source = "../modules/cloned_vm"

  proxmox_endpoint = var.proxmox_endpoint
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  use_qemu_agent = true 

  node_name = "homelab"
  name = "k8s-server"
  description = "Hosts Rancher dashboard to control public and internal clusters"
  vm_id = 5001
  template_id = 100

  cpus = 4 
  memory = 8192
  disk_size = 200
}

resource "local_file" "k8s_ansible_inventory" {
  filename = var.inventory_file 
  content = <<EOF
[k8s-server]
${join("\n", module.k8s_server.ip)} hostname=k8s-server disk_size=200
EOF
}