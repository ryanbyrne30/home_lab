terraform {
    # source (https://registry.terraform.io/providers/bpg/proxmox/latest/docs)

    backend "s3" {
        # set AWS access key: export AWS_ACCESS_KEY_ID=mykey
        # set AWS secret access key: export AWS_SECRET_ACCESS_KEY=AAAA...

        bucket = "ryanbyrne30-homelab-config" 
        key = "terraform/common.tfstate"
        region = "us-west-1" 
    }
}

module "cluster" {
    source = "../modules/stacks/cluster"

    proxmox_endpoint = var.proxmox_endpoint
    proxmox_username = var.proxmox_username
    proxmox_password = var.proxmox_password

    node_name = "homelab"

    inventory_file = ".output/inventory.ini"

    router_id = 3000
    router_template_id = 102

    k8s_server_cpus = 2
    k8s_server_memory = 4096
    k8s_server_disk_size = 50
    k8s_server_id = 3001
    k8s_server_template_id = 100
}