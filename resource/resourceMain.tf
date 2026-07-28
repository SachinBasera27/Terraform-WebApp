resource "azurerm_storage_account" "stacc-tf-webapp" {
  name                     = "stacctfwebapp"
  resource_group_name      = module.data.Rg-name
  location                 = module.data.Rg-location
  account_tier             = "Standard"
  account_kind             = "BlobStorage"
  access_tier              = "Hot"
  account_replication_type = "GRS"
  shared_access_key_enabled = true
  public_network_access_enabled = true
}

resource "azurerm_storage_container" "cont-tf-webapp" {
  name                  = "tf-prod-webapp"
  storage_account_id    = azurerm_storage_account.stacc-tf-webapp.id
  container_access_type = "private"
}