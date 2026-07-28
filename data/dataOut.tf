output "sas_url_query_string" {
  value = data.azurerm_storage_account_sas.example.sas
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "object_id" {
  value = data.azurerm_client_config.current.object_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

output "Rg-name" {
  value = data.azurerm_resource_group.existing-rg.name
}

output "Rg-location" {
  value = data.azurerm_resource_group.existing-rg.location
}