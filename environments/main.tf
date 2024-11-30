terraform {
  backend "azurerm" {
    # Backend configuration is provided via CLI
  }
}

data "azurerm_client_config" "current" {}

# Fetch the pre-existing DNS zone
data "azurerm_dns_zone" "existing_dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.core_resource_group_name
}

module "resource_group" {
  source                 = "../modules/resource_group"
  application_key        = var.application_key
  environment_key        = var.environment_key
  resource_group_location = var.resource_group_location
}

module "static_website" {
  source                      = "../modules/static_website"
  application_key             = var.application_key
  environment_key             = var.environment_key
  resource_group_name         = module.resource_group.name
  location                    = var.static_website_location
  dns_zone_resource_group_name = var.core_resource_group_name
  dns_zone_name               = data.azurerm_dns_zone.existing_dns_zone.name

  depends_on = [module.resource_group]
}

module "function_app" {
  source                      = "../modules/function_app"
  application_key             = var.application_key
  environment_key             = var.environment_key
  resource_group_name         = module.resource_group.name
  resource_group_location     = module.resource_group.location
  dns_zone_resource_group_name = var.core_resource_group_name
  dns_zone_name               = data.azurerm_dns_zone.existing_dns_zone.name

  depends_on = [module.resource_group]
}
