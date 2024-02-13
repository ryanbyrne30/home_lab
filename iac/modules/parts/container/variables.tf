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

variable "vm_depends_on" {
    type = any 
    default = [] 
}

variable "name" {
    type = string
    description = "Name to give VM"
}

variable "description" {
    type = string
    description = "Description to give VM"
    default = ""
}

variable "tags" {
    type = list(string)
    description = "Tags to give to VM"
    default = [ ]
}

variable "node_name" {
    type = string
    description = "Name of the Proxmox node to deploy VM to"
}

variable "vm_id" {
    type = number
    description = "VM ID to assign to VM"
}

variable "hostname" {
    type = string
}

variable "network_devices" {
    type = list(object({
        name = optional(string, "eth0")
        bridge = optional(string, "vmbr0") 
        vlan_id = optional(number)
        address = optional(string, "dhcp")
        gateway = optional(string)
    }))
    description = "List of network devices to add to VM. Address is IP address in CIDR notation."
    default = [{
        address = "dhcp",
        bridge = "vmbr0"
    }]
}

variable "ssh_keys" {
    type = list(string) 
    description = "SSH root public key"
    default = [ ]
}

variable "root_password" {
    type = string
    description = "Root password"
    nullable = true
}

variable "mounts" {
    type = list(object({
        volume = string,                # ex. local-lvm, /mnt/shared
        size = optional(string, "10G"),
        path = string,                  # ex. /mnt/volume
    }))
    description = "List of mounts to bind to container. volume (local-lvm, /mnt/shared), path - where the volume is mounted to in container."
    default = []
}

variable "image_id" {
    type = string
}

variable "image_type" {
    type = string 
    nullable = true 
    default = null
}

variable "disk_store" {
    type = string 
    description = "Datastore to create disk in"
    default = "locallvm"
}

variable "disk_size" {
    type = number
    description = "Number of GB of disk space to allocate to VM"
    default = 4 
}

variable "cpu_cores" {
    type = number
    description = "CPU cores"
    default = null
    nullable = true
}

variable "cpu_units" {
    type = number 
    description = "CPU units to allocate"
    nullable = true
    default = null
}

variable "memory" {
    type = number
    description = "Amount of RAM to allocate in MB"
    default = 512
}

variable "swap" {
    type = number
    description = "Amount of SWAP memory to allocate in MB"
    default = 0
}