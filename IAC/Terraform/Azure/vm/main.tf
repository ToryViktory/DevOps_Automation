resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = format("rg-%s-%s-%s",var.name_prefix,var.env,var.location)
}

# Create virtual network
resource "azurerm_virtual_network" "terraform_vnet" {
  name                = format("vnet-%s-%s-%s",var.name_prefix,var.env,var.location)
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "terraform_subnet" {
  name                 = format("snet-%s-%s-%s",var.name_prefix,var.env,var.location)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.terraform_vnet.name
  address_prefixes     = var.snet_address_space
}

# Create public IPs
resource "azurerm_public_ip" "public_ip" {
  name                = format("pip-%s-%s-%s",var.name_prefix,var.env,var.location)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "terraform_nsg" {
  name                = format("nsg-%s-%s-%s",var.name_prefix,var.env,var.location)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "195.56.119.209"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "terraform_nic" {
  name                = format("nic-%s-%s-%s",var.name_prefix,var.env,var.location)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic_config"
    subnet_id                     = azurerm_subnet.terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.terraform_nic.id
  network_security_group_id = azurerm_network_security_group.terraform_nsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage_account" {
  name                     = format("st%s%s%s",var.name_prefix,var.env,var.location)
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "terraform_vm" {
  name                  = format("vm-%s-%s-%s",var.name_prefix,var.env,var.location)
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.terraform_nic.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = format("disk%s%s%s",var.name_prefix,var.env,var.location)
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.os_info[0].publisher
    offer     = var.os_info[0].offer
    sku       = var.os_info[0].sku
    version   = var.os_info[0].version
  }

  computer_name  = "hostname"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }
}