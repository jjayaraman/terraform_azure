resource "azurerm_resource_group" "kv_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                            = "${var.keyvault_name_prefix}_${var.environment}"
  resource_group_name             = azurerm_resource_group.kv_rg.name
  location                        = azurerm_resource_group.kv_rg.location
  sku_name                        = "standard"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
}
