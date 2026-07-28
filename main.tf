module "resource" {
  source = "./resource"
}

provider "azurerm" {
  features {}
}

resource "azurerm_service_plan" "sp-tf" {
  name                = "terraform_servicePlan"
  resource_group_name = module.resource.name
  location            = module.resource.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "example" {
  name                = "webapp"
  resource_group_name = module.resource.name
  location            = azurerm_service_plan.sp-tf.location
  service_plan_id     = azurerm_service_plan.sp-tf.id

  site_config {
    ftps_state = "AllAllowed"
    worker_count = 2
    always_on = true
  }

  logs{
    application_logs {
      file_system_level = "Warning"
      azure_blob_storage {
        level = "Warning"
        retention_in_days = 7
        sas_url = "https://${azurerm_storage_account.stacc-tf-webapp.name}.blob.core.windows.net/${azurerm_storage_container.cont-tf-webapp.name}${module.data.sas_url_query_string}&sr=b}"
      }
    }
  }

  auth_settings_v2 {
    login {
      token_store_enabled = true

    }

    auth_enabled = true
    unauthenticated_action = "Return401"
    default_provider = "azureactivedirectory"

    active_directory_v2 {
      client_id = "3b0c09a6-c758-429e-ba3f-1f05f49cbaaa"
      tenant_auth_endpoint = "https://login.microsoftonline.com/9afed3ec-3a05-4b0c-92a9-07ac07939ec5/"
    }
  }

  backup {
    name = "test-backup"

    schedule {
      retention_period_days = 8
      frequency_interval = 2
      frequency_unit = "Day"
      keep_at_least_one_backup = true
      }

    storage_account_url = "https://${azurerm_storage_account.stacc-tf-webapp.name}.blob.core.windows.net/${azurerm_storage_container.cont-tf-webapp.name}${module.data.sas_url_query_string}&sr=b}"
  }

  identity {type = "SystemAssigned , UserAssigned"}



}



