resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.application_key}-core"
  location = var.resource_group_location
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.resource_group.name
}
