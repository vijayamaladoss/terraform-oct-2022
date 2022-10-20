output "resource_group_name" {
    value = azurerm_resource_group.rg.name
}

output "lb_public_static_ip_address" {
    value = azurerm_public_ip.lb-public-ip
}

output "public_vm_ip_addresses" {
    value = azurerm_linux_virtual_machine.my_ubuntu_vm.*.public_ip_address
}

output "tls_private_key" {
  value = tls_private_key.my_ssh_key.private_key_pem
  sensitive = true
}

output "ssh_key" {
  description = "ssh key generated by terraform"
  value       = tls_private_key.my_ssh_key.private_key_pem
  sensitive = true
}
