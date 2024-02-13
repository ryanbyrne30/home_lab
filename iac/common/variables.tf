variable "proxmox_endpoint" {
    type = string 
    description = "Proxmox endpoint. Ex: https://proxmox.homelab.local:8006/"
}

variable "proxmox_username" {
    type = string
}

variable "proxmox_password" {
    type = string
}

variable "inventory_file" {
    type = string
    description = "Where to output the inventory file to for Ansible"
    default = "output/inventory.ini"
}

# variable "ssh_key" {
#     type = string
# }

# variable "admin_password" {
#     type = string
# }