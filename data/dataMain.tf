data "azurerm_storage_account_sas" "example" {
  connection_string = module.resource.stacc-tf-webapp.primary_connection_string
  https_only        = true
  signed_version    = "2022-11-02"

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2026-07-21T00:00:00Z"
  expiry = "2027-07-21T00:00:00Z"

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

# Using RG from another project that exists in Azure [Used in Terraform VM Proj]

data "azurerm_resource_group" "existing-rg"{
  name = "rg-terraform"
}


data "azurerm_client_config" "current" {}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
# https://developer.hashicorp.com/terraform/language/data-sources?utm_source=chatgpt.com
