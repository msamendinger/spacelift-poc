resource "azurerm_virtual_network" "spacelift" {
  name                = "spacelift-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.spacelift.location
  resource_group_name = azurerm_resource_group.spacelift.name
}

resource "azurerm_subnet" "spacelift" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.spacelift.name
  virtual_network_name = azurerm_virtual_network.spacelift.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "spacelift" {
  name                = "spacelift-nic"
  location            = azurerm_resource_group.spacelift.location
  resource_group_name = azurerm_resource_group.spacelift.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spacelift.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "spacelift" {
  name                = "spacelift-machine"
  resource_group_name = azurerm_resource_group.spacelift.name
  location            = azurerm_resource_group.spacelift.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.spacelift.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/mnt/workspace/azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}


resource "azurerm_network_interface" "spacelift-worker" {
  name                = "spacelift-worker-nic"
  location            = azurerm_resource_group.spacelift.location
  resource_group_name = azurerm_resource_group.spacelift.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spacelift.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.spacelift-worker.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_public_ip" "spacelift-worker" {
  name                = "spacelift-worker-public-ip"
  resource_group_name = azurerm_resource_group.spacelift.name
  location            = azurerm_resource_group.spacelift.location
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "spacelift-worker" {
  name                = "spacelift-worker"
  resource_group_name = azurerm_resource_group.spacelift.name
  location            = azurerm_resource_group.spacelift.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.spacelift-worker.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/mnt/workspace/azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
