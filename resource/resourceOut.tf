output "blob"{
    value = azurerm_storage_container.cont-tf-webapp.id
}

output "container" {
  value = azurerm_storage_account.stacc-tf-webapp.id
}