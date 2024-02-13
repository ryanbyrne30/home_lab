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

variable "node_name" {
    type = string 
    description = "Name of the node to deploy VLAN to"
}

variable "vlan_id" {
    type = number
    description = "VLAN tag"
}

variable "comment" {
    type = string
    description = "Description of VLAN"
    default = ""
}

variable "interface" {
    type = string 
    description = "Name of interface to create VLAN off of"
    default = "vmbr0"
}

variable "ipv4_cidr" {
    type = string 
    description = "IPV4 CIDR for this VLAN"
    nullable = true
    default = null 
}

variable "ipv4_gateway" {
    type = string 
    description = "IPV4 gateway for this VLAN"
    nullable = true
    default = null 
}
