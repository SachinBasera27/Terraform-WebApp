output "name" {
    value = azurerm_resource_group.RG-GH-Terraform.name
}

output "location" {
    value = azurerm_resource_group.RG-GH-Terraform.location
}

output "blob"{
    value = azurerm_storage_container.cont-tf-webapp.id
}

output "container" {
  value = azurerm_storage_account.stacc-tf-webapp.id
}