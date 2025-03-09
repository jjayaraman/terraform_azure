resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "my_storage" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = false
}

resource "azurerm_storage_container" "my_storage_container" {
  name                  = "mycontainer"
  storage_account_id    = azurerm_storage_account.my_storage.id
  container_access_type = "private"
}
