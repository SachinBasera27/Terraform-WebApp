variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

resource "azurerm_managed_disk" "dataDiskVM" {
  name                 = "dd-vm"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

