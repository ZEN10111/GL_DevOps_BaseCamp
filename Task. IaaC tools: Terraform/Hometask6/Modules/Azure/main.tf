
resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.prefix}-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  custom_data         = filebase64(var.user_data)
  network_interface_ids = [
    "${azurerm_network_interface.main.id}"
  ]

  admin_ssh_key {
    username   = var.admin_ssh_key_username
    public_key = file(var.ssh_pub_key)
  }

  source_image_reference {
    publisher = var.distr_publisher
    offer     = var.distr_offer
    sku       = var.distr_sku
    version   = var.distr_version
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
