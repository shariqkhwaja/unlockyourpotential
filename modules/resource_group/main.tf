resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.application_key}-${var.environment_key}"
  location = var.resource_group_location
}
