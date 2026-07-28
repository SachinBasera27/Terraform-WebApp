resource "azurerm_key_vault" "kv-tf-webapp" {
  name                        = "kv-tf-wa"
  location                    = module.resource.location
  resource_group_name         = module.resource.name
  rbac_authorization_enabled  = true
  enabled_for_disk_encryption = true
  tenant_id                   = module.data.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enabled_for_template_deployment = true
  public_network_access_enabled = true


  sku_name = "standard"

  access_policy {

    tenant_id = module.data.tenant_id
    object_id = module.data.object_id
    application_id = module.data.application_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}