resource "azurerm_resource_group" "RG-GH-Terraform" {
  name     = "rg-terraform-webapp"
  location = "Central US"
}

resource "azurerm_storage_account" "stacc-tf-webapp" {
  name                     = "stacctf-webapp"
  resource_group_name      = azurerm_resource_group.RG-GH-Terraform.name
  location                 = azurerm_resource_group.RG-GH-Terraform.location
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