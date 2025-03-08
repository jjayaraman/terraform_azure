terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Stores TF state in Azure storage
  backend "azurerm" {
    resource_group_name  = "value"
    storage_account_name = "value"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
    # snapshot             = true # Enable versioning for state rollback
  }

}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
