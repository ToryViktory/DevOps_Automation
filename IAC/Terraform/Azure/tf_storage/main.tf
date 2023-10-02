resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = format("rg-%s-tfstate-%s",var.name_prefix,var.location)
}

resource "azurerm_storage_account" "tfstate" {
  name                     = format("tfstate%s%s",var.name_prefix,var.location)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment = var.target_env_scope
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}