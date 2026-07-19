resource "azurerm_resource_group" "RG-GH-Terraform" {
  name     = "rg-terraform"
  location = "Central US"
}

resource "azurerm_storage_account" "stacc-tf" {
  name                     = "stacctf"
  resource_group_name      = azurerm_resource_group.RG-GH-Terraform.name
  location                 = azurerm_resource_group.RG-GH-Terraform.location
  account_tier             = "Standard"
  account_kind             = "BlobStorage"
  access_tier              = "Hot"
  account_replication_type = "GRS"
  shared_access_key_enabled = true
  public_network_access_enabled = true
}

resource "azurerm_storage_container" "cont-tf" {
  name                  = "tf-prod"
  storage_account_id    = azurerm_storage_account.stacc-tf.id
  container_access_type = "private"
}