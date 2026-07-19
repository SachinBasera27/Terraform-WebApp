terraform {
  backend "azurerm" {
    use_oidc             = true
    use_azuread_auth     = true
    storage_account_name = "stacctf"
    container_name       = "tf-prod"
    key                  = "terraform.tfstate"
  }
}
