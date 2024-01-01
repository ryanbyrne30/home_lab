output "cloned_vm" {
  value = proxmox_virtual_environment_vm.cloned_vm.ipv4_addresses[1][0]
}