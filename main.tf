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
}



