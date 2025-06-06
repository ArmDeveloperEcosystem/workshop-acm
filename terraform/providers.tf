terraform {
  required_version = ">=1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.26"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.7"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}