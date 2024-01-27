variable "vm_depends_on" {
    type = any 
    default = [] 
}

variable "use_qemu_agent" {
    type = bool
    default = false
    description = "Whether to use QEMU Guest Agent. (QEMU Guest Agent must already be installed on the template)"
}

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

variable "template_id" {
    type = number
    description = "ID of the template to clone"
}

variable "cpus" {
    type = number
    description = "Number of CPU cores to allocate to VM"
    default = 1
}

variable "memory" {
    type = number
    description = "Number of MB of memory to allocate to VM"
    default = 1024 
}

variable "disk_size" {
    type = number
    description = "Number of GB of disk space to allocate to VM"
    default = 8
}

variable "network_devices" {
    type = list(object({
        bridge = optional(string, "vmbr0") 
        vlan_id = optional(number)
        address = optional(string, "dhcp")
        gateway = optional(string)
    }))
    description = "List of network devices to add to VM. Address is IP address in CIDR notation."
    default = []
}

variable "disks" {
    type = list(object({
      datastore_id = optional(string, "local-lvm")
      size = optional(number, 8)
    }))
    default = []
}