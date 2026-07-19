variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}


resource "azurerm_virtual_network" "vnet-terraform" {
  name                = "vnetTf"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet-terraform" {
  name                 = "subnetTf"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-terraform.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic-terraform" {
  name                = "nic-tf"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet-terraform.id
    private_ip_address_allocation = "Dynamic"
  }
}