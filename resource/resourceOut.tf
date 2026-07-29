output "cont-id"{
  value = azurerm_storage_container.cont-tf-webapp.id
}

output "cont-name"{
  value = azurerm_storage_container.cont-tf-webapp.name
}

output "storage-account-id" {
  value = azurerm_storage_account.stacc-tf-webapp.id
}

output "storage-account-name" {
  value = azurerm_storage_account.stacc-tf-webapp.name
}

output "sas_url_query_string" {
  value = data.azurerm_storage_account_sas.SAS_URL.sas
  sensitive = true
}
