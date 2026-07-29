output "key_vault_id" {
  value = azurerm_key_vault.kv-tf-webapp.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv-tf-webapp.vault_uri
}