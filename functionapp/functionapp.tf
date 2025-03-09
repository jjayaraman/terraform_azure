resource "azurerm_resource_group" "fa_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "fa_storage" {
  name                     = "${var.storage_name_prefix}${var.functionapp_name}${var.environment}"
  resource_group_name      = azurerm_resource_group.fa_rg.name
  location                 = azurerm_resource_group.fa_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "fa_service_plan" {
  name                = "asp-${var.functionapp_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.fa_rg.name
  location            = azurerm_resource_group.fa_rg.location
  os_type             = "Linux"
  sku_name            = "EP1" # Elastic Premium Plan (Flex Consumption)
}

resource "azurerm_linux_function_app" "function_app" {
  name                 = var.functionapp_name
  resource_group_name  = azurerm_resource_group.fa_rg.name
  location             = azurerm_resource_group.fa_rg.location
  service_plan_id      = azurerm_service_plan.fa_service_plan.id
  storage_account_name = azurerm_storage_account.fa_storage.name

  site_config {
    linux_fx_version = "Python|3.9"
    always_on        = false # Recommended for Flex Consumption
    application_stack {
      python_version = "3.9"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME     = "python"
    WEBSITE_RUN_FROM_PACKAGE     = "1"
    FUNCTION_APP_EDIT_MODE       = "readonly"
    WEBSITE_NODE_DEFAULT_VERSION = "~18"
  }

  identity {
    type = "SystemAssigned" # Managed Identity
  }
}

# 🔹 Output Function App URL
output "function_app_url" {
  value = azurerm_linux_function_app.function_app.default_hostname
}
