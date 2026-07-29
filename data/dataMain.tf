# Using RG from another project that exists in Azure [Used in Terraform VM Proj]
data "azurerm_resource_group" "existing-rg"{
  name = "rg-terraform"
}


data "azurerm_client_config" "current" {}



# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
# https://developer.hashicorp.com/terraform/language/data-sources?utm_source=chatgpt.com