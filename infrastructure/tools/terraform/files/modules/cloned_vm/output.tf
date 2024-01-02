output "ip" {
  value = flatten([
    for sublist in proxmox_virtual_environment_vm.cloned_vm.ipv4_addresses : [
      for ip in sublist :
        regexall("^192\\.168\\.0\\.[0-9]+$", ip) != [] ? ip : null
    ] 
  ])[1]
}
