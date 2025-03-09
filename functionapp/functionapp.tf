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

  network_rules {
    default_action = "Allow"           # Deny all traffic except allowed IPs
    bypass         = ["AzureServices"] # Allows Azure services to access  
  }
}

resource "azurerm_service_plan" "fa_service_plan" {
  name                = "asp-${var.functionapp_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.fa_rg.name
  location            = azurerm_resource_group.fa_rg.location
  os_type             = "Windows"
  sku_name            = "Y1" # Consumption plan
}

resource "azurerm_windows_function_app" "function_app" {
  name                 = var.functionapp_name
  resource_group_name  = azurerm_resource_group.fa_rg.name
  location             = azurerm_resource_group.fa_rg.location
  service_plan_id      = azurerm_service_plan.fa_service_plan.id
  storage_account_name = azurerm_storage_account.fa_storage.name

  site_config {
    always_on = false
    application_stack {
      node_version = "~22" # Node.js version
    }
  }

  app_settings = {

  }

  identity {
    type = "SystemAssigned" # Managed Identity
  }
}

# 🔹 Assign Storage Blob Data Contributor access to Function app
resource "azurerm_role_assignment" "function_app_fa_storage_access" {
  principal_id         = azurerm_windows_function_app.function_app.identity[0].principal_id
  scope                = azurerm_storage_account.fa_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  depends_on           = [azurerm_windows_function_app.function_app]
}

# 🔹 Output Function App URL
output "function_app_url" {
  value = azurerm_windows_function_app.function_app.default_hostname
}
