terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Stores TF state in Azure storage
  backend "azurerm" {}

}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
