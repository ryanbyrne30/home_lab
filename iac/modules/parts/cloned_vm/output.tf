output "ip" {
  value = flatten([
    for sublist in proxmox_virtual_environment_vm.cloned_vm.ipv4_addresses : [
      for ip in sublist :
        ip if startswith(ip, "192.168.0.") 
    ]
  ])
}
