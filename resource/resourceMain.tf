resource "azurerm_storage_account" "stacc-tf-webapp" {
  name                     = "stacctfwebapp"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
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

data "azurerm_storage_account_sas" "SAS_URL" {
  connection_string = azurerm_storage_account.stacc-tf-webapp.primary_connection_string
  https_only        = true
  signed_version    = "2022-11-02"

  resource_types {
    service   = false
    container = true  
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2026-07-21T00:00:00Z"
  expiry = "2026-10-21T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}