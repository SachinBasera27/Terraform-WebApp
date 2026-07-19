output "subnet_id"{
    value = azurerm_subnet.subnet-terraform.id
}

output "vnet_id"{
    value = azurerm_virtual_network.vnet-terraform.id
}

output "nic_id"{
    value = azurerm_network_interface.nic-terraform.id
}