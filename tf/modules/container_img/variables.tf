variable "proxmox_endpoint" {
    type = string
    description = "Proxmox endpoint. Ex: https://proxmox.homelab.local:8006/"
}

variable "proxmox_username" {
    type = string 
    description = "Proxmox username"
}

variable "proxmox_password" {
    type = string 
    description = "Proxmox password"
}

variable "content_type" {
    type = string
    nullable = true 
    default = "vztmpl"
}

variable "datastore_id" {
    type = string
    default = "local"
}

variable "node_name" {
    type = string
}

variable "url" {
    type = string
}

variable "file_name" {
    type = string 
    nullable = true 
    default = null
}
