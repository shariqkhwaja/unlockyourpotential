terraform {
  backend "azurerm" {
    # Empty backend configuration; actual configuration will be provided via CLI
  }
}

data "azurerm_client_config" "current" {}

module "domain_name" {
  count = var.environment_key == "core" ? 1 : 0
  source = "../modules/domain_name"
  application_key = var.application_key
  environment_key = var.environment_key
  resource_group_location = var.resource_group_location
  dns_zone_name = var.dns_zone_name
}

module "resource_group" {
  source              = "../modules/resource_group"
  application_key = var.application_key
  environment_key = var.environment_key
  resource_group_location = var.resource_group_location
}

module "static_website_non_prod" {
  source = "../modules/static_website_non_prod"
  application_key = var.application_key
  environment_key = var.environment_key
  resource_group_name = module.resource_group.name
  location = var.static_website_location
  dns_zone_resource_group_name = module.domain_name.resource_group_name
  dns_zone_name = module.domain_name.name

  depends_on = [ module.resource_group ]
}

module "function_app" {
  source = "../modules/function_app"
  application_key = var.application_key
  environment_key = var.environment_key
  resource_group_name = module.resource_group.name
  resource_group_location = module.resource_group.location
  dns_zone_resource_group_name = module.domain_name.resource_group_name
  dns_zone_name = module.domain_name.name
  allowed_origins = var.allowed_origins

  depends_on = [ module.resource_group ]
}