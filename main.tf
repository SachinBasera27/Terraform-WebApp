module "resource" {
  source                  = "./resource"
  resource_group_name     = module.data.Rg-name
  resource_group_location = module.data.Rg-location
}

module "data" {
  source = "./data"
}

module "keyvault" {
  source                  = "./KeyVault"
  resource_group_name     = module.data.Rg-name
  resource_group_location = module.data.Rg-location
  tenant_id               = module.data.tenant_id
}

resource "azurerm_role_assignment" "Role1" {
  scope                = "/subscriptions/${module.data.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = module.data.object_id
}

# SP will have storage blob data contributor role to access the storage account and container for logging and backup for this webapp
resource "azurerm_role_assignment" "Role2" {
  scope                = "/subscriptions/${module.data.subscription_id}/resourceGroups/${module.data.Rg-name}/providers/Microsoft.Storage/storageAccounts/${module.resource.storage-account-name}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.data.object_id
}

# SP will have storage blob data contributor role to access the storage account for backend.tf
resource "azurerm_role_assignment" "Role3" {
  scope                = "/subscriptions/${module.data.subscription_id}/resourceGroups/${module.data.Rg-name}/providers/Microsoft.Storage/storageAccounts/stacctf/blobServices/default/containers/tfprod"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.data.object_id
}

resource "azurerm_service_plan" "sp-tf" {
  name                = "terraform_servicePlan"
  resource_group_name = module.data.Rg-name
  location            = module.data.Rg-location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "example" {
  name                = "webapp"
  resource_group_name = module.data.Rg-name
  location            = module.data.Rg-location
  service_plan_id     = azurerm_service_plan.sp-tf.id

  site_config {
    ftps_state   = "AllAllowed"
    worker_count = 2
    always_on    = true
  }

  logs {
    application_logs {
      file_system_level = "Warning"
      azure_blob_storage {
        level             = "Warning"
        retention_in_days = 7
        sas_url           = "https://${module.resource.storage-account-name}.blob.core.windows.net/${module.resource.cont-name}${module.resource.sas_url_query_string}"
      }
    }
  }

  auth_settings_v2 {
    login {
      token_store_enabled = true

    }

    auth_enabled           = true
    unauthenticated_action = "Return401"
    default_provider       = "azureactivedirectory"

    active_directory_v2 {
      client_id            = "3b0c09a6-c758-429e-ba3f-1f05f49cbaaa"
      tenant_auth_endpoint = "https://login.microsoftonline.com/9afed3ec-3a05-4b0c-92a9-07ac07939ec5/"
    }
  }

  backup {
    name = "test-backup"

    schedule {
      retention_period_days    = 8
      frequency_interval       = 2
      frequency_unit           = "Day"
      keep_at_least_one_backup = true
    }

    storage_account_url = "https://${module.resource.storage-account-name}.blob.core.windows.net/${module.resource.cont-name}${module.resource.sas_url_query_string}"
  }

  identity { type = "SystemAssigned" }
}



