resource "azurerm_key_vault" "kv-tf-webapp" {
  name                        = "kv-tf-wa"
  location                    = module.data.Rg-location
  resource_group_name         = module.data.Rg-name
  rbac_authorization_enabled  = true
  enabled_for_disk_encryption = true
  tenant_id                   = module.data.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enabled_for_template_deployment = true
  public_network_access_enabled = true


  sku_name = "standard"

}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault