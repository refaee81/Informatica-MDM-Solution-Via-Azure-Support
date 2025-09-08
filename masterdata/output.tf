# Provides output info on SFTP password if service is enabled for storage account
/* output "sftpPassword" {
  value = {
    for instance in keys(var.storage_accounts) :
    instance => module.storage_account[instance].sftp_password
  }
} */

# Provides output for each created Virtual Machine
output "vm_details" {
  value = {
    for instance in keys(var.compute) :
    instance => {
      vm_name             = module.virtual_machine[instance].name
      vm_id               = module.virtual_machine[instance].linux_id
      vm_managed_identity = module.virtual_machine[instance].managed_identity_object_id
      vm_private_ip       = [module.virtual_machine[instance].private_ip_address]
    }
  }
}


