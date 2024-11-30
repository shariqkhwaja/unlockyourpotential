terraform {
  backend "azurerm" {
    # Empty backend configuration; actual configuration will be provided via CLI
  }
}

data "azurerm_client_config" "current" {}

module "domain_name" {
  source = "../modules/domain_name"
  application_key = var.application_key
  environment_key = var.environment_key
  resource_group_location = var.resource_group_location
  dns_zone_name = var.dns_zone_name
}