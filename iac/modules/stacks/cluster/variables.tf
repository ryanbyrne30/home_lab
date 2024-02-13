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

variable "node_name" {
    type = string
    description = "Name of Proxmox node"
}

variable "router_id" {
    type = number
    description = "VM ID for router"
}

variable "router_template_id" {
    type = number
    description = "Template id for VyOS"
}

variable "k8s_server_id" {
    type = number
    description = "VM ID for K8s server"
}

variable "k8s_server_template_id" {
    type = number
    description = "Template id for K8s server"
}

variable "k8s_server_cpus" {
    type = number
    description = "Number of CPUs for K8s server"
}

variable "k8s_server_memory" {
    type = number
    description = "Memory in MB for K8s server"
}

variable "k8s_server_disk_size" {
    type = number
    description = "Storage in GB for K8s server"
}
