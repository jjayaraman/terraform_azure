resource "azurerm_resource_group" "tf_state_rg" {
  count    = length(data.azurerm_resource_group.tf_state_rg_existing.name) > 0 ? 0 : 1 // if resource group does not exist create
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "tf_state_storage" {
  name                     = "${var.storage_name_prefix}${var.environment}"
  resource_group_name      = length(azurerm_resource_group.tf_state_rg) > 0 ? azurerm_resource_group.tf_state_rg[0].name : data.azurerm_resource_group.tf_state_rg_existing.name
  location                 = length(azurerm_resource_group.tf_state_rg) > 0 ? azurerm_resource_group.tf_state_rg[0].location : data.azurerm_resource_group.tf_state_rg_existing.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tf_state_storage_container" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tf_state_storage.id
  container_access_type = "private"
}

# resource "azurerm_storage_account_network_rules" "storagetf_state_storage_rules" {
#   storage_account_id = azurerm_storage_account.tf_state_storage.id

#   default_action = "Deny"           # Deny all traffic except allowed IPs
#   ip_rules       = ["4.148.0.0/16"] # Allow only Github actions
# }
