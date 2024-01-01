# Terraform

Terraform is a provisioning tool used for infrastructure as code (IAC).

## Resources

[(Blog) Managing Terraform State](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)

## Proxmox IAC

[source](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)

### [Creating a Proxmox User and Role for Terraform](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs#creating-the-proxmox-user-and-role-for-terraform)

```bash
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
pveum user add terraform-prov@pve --password <password>
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

Pass them to Terraform via environment variables:

```bash
export PROXMOX_VE_USERNAME=root@pam
export PROXMOX_VE_PASSWORD=mypassword
```

_Terraform also supports other methods of authentication using API tokens, however this may result in a limitation of actions. For example, VM.Clone permissions require basic authentication._
