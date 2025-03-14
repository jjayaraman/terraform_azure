resource "azurerm_resource_group" "tf_state_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "tf_state_storage" {
  name                     = "${var.storage_name_prefix}${var.environment}"
  resource_group_name      = azurerm_resource_group.tf_state_rg.name
  location                 = azurerm_resource_group.tf_state_rg.location
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
