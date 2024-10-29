terraform {
  required_version = ">= 1.9.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.7.0"
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}