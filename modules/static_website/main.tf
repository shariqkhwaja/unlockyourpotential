resource "azurerm_static_web_app" "static_web_app" {
  name                = "sw-${var.application_key}-${var.environment_key}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_dns_cname_record" "cname_record" {
  resource_group_name = var.dns_zone_resource_group_name
  zone_name           = var.dns_zone_name
  name                = var.environment_key
  record              = azurerm_static_web_app.static_web_app.default_host_name
  ttl                 = 60  
  lifecycle {
    ignore_changes = [record]
  }

  depends_on = [ azurerm_static_web_app.static_web_app ]
}

resource "azurerm_static_web_app_custom_domain" "static_web_app_custom_domain" {
  static_web_app_id = azurerm_static_web_app.static_web_app.id
  domain_name       = "${var.environment_key}.${var.dns_zone_name}"
  validation_type   = "cname-delegation"

      timeouts {
    create = "30m"
    delete = "30m"
  }

  depends_on = [ azurerm_dns_cname_record.cname_record ]
}

##############

resource "azurerm_dns_cname_record" "cname_record_prod" {
  count = var.environment_key == "prd" ? 1 : 0
  name                = "www"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 60
  record              = azurerm_static_web_app.static_web_app.default_host_name
  # Consider adding lifecycle to ignore changes to 'record' to avoid unnecessary updates.
  lifecycle {
    ignore_changes = [record]
  }
}

# Create the apex domain (prod only)

resource "azurerm_dns_a_record" "apex" {
  count = var.environment_key == "prd" ? 1 : 0
  name                = "@"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 60
  target_resource_id  = azurerm_static_web_app.static_web_app.id
}

resource "azurerm_static_web_app_custom_domain" "apex" {
  count = var.environment_key == "prd" ? 1 : 0
  static_web_app_id = azurerm_static_web_app.static_web_app.id
  domain_name     = "${var.dns_zone_name}"
  validation_type = "dns-txt-token"
  # Add dependency or checks to make sure domain validation is successful

    timeouts {
    create = "30m"
    delete = "30m"
  }

  depends_on = [ azurerm_dns_a_record.apex, azurerm_dns_cname_record.cname_record_prod ]
}

resource "azurerm_dns_txt_record" "apex" {
  count = var.environment_key == "prd" ? 1 : 0
  name                = "@"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 60
  record {
    value = azurerm_static_web_app_custom_domain.apex[0].validation_token
  }
  depends_on = [azurerm_static_web_app_custom_domain.apex]
  # Explicitly specify that this depends on the apex custom domain validation
}