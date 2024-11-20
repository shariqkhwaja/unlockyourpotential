terraform {
  backend "azurerm" {
    # Empty backend configuration; actual configuration will be provided via CLI
  }
}


data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

# resource "azurerm_resource_group" "resource_group" {
#   name     = var.resource_group_name
#   location = var.resource_group_location
# }

module "resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
}

resource "azurerm_application_insights" "application_insights" {
  name                = "ai-${var.application_key}-${var.environment_key}"
  location            = var.resource_group_location
  resource_group_name = module.resource_group.name
  application_type    = "web"

  depends_on = [module.resource_group]
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = module.resource_group.name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"  # Disable support for TLS versions below 1.2

  depends_on = [module.resource_group]
}

resource "azurerm_static_web_app" "static_web_app" {
  name                = var.static_web_app_name
  resource_group_name = module.resource_group.name
  location            = var.static_website_location
}

# Create the cnames

resource "azurerm_dns_cname_record" "cname_record_non_prod" {
  count = var.environment_key != "prd" ? 1 : 0
  name                = var.environment_key
  zone_name           = var.dns_zone_name
  resource_group_name = var.core_resource_group_name
  ttl                 = 60
  record              = azurerm_static_web_app.static_web_app.default_host_name
  # Consider adding lifecycle to ignore changes to 'record' to avoid unnecessary updates.
  lifecycle {
    ignore_changes = [record]
  }
}

resource "azurerm_dns_cname_record" "cname_record_prod" {
  count = var.environment_key == "prd" ? 1 : 0
  name                = "www"
  zone_name           = var.dns_zone_name
  resource_group_name = var.core_resource_group_name
  ttl                 = 60
  record              = azurerm_static_web_app.static_web_app.default_host_name
  # Consider adding lifecycle to ignore changes to 'record' to avoid unnecessary updates.
  lifecycle {
    ignore_changes = [record]
  }
}

resource "azurerm_static_web_app_custom_domain" "static_web_app_custom_domain" {
  count = var.environment_key != "prd" ? 1 : 0
  static_web_app_id = azurerm_static_web_app.static_web_app.id
  domain_name       = "${var.environment_key}.${var.dns_zone_name}"
  validation_type   = "cname-delegation"

      timeouts {
    create = "30m"
    delete = "30m"
  }

    depends_on = [azurerm_static_web_app.static_web_app, azurerm_dns_cname_record.cname_record_non_prod]
}


# Create the apex domain

resource "azurerm_dns_a_record" "apex" {
  count = var.environment_key == "prd" ? 1 : 0
  name                = "@"
  zone_name           = var.dns_zone_name
  resource_group_name = var.core_resource_group_name
  ttl                 = 60
  target_resource_id  = azurerm_static_web_app.static_web_app.id
}

resource "azurerm_static_web_app_custom_domain" "apex" {
  count = var.environment_key != "prd" ? 1 : 0
  static_web_app_id = azurerm_static_web_app.static_web_app.id
  domain_name     = "${var.dns_zone_name}"
  validation_type = "dns-txt-token"
  # Add dependency or checks to make sure domain validation is successful

    timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "azurerm_dns_txt_record" "apex" {
  count = var.environment_key == "prd" ? 1 : 0
  name                = "@"
  zone_name           = var.dns_zone_name
  resource_group_name = var.core_resource_group_name
  ttl                 = 60
  record {
    value = azurerm_static_web_app_custom_domain.apex[0].validation_token
  }
  depends_on = [azurerm_static_web_app_custom_domain.apex]
  # Explicitly specify that this depends on the apex custom domain validation
}
 

#################################
## START function app SPECIFIC CODE
#################################

resource "azurerm_service_plan" "service_plan" {
  name                = "as-${var.application_key}-${var.environment_key}"
  resource_group_name = module.resource_group.name
  location            = var.resource_group_location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function_app" {
  name                = "fa-${var.application_key}-${var.environment_key}"
  resource_group_name = module.resource_group.name
  location            = var.resource_group_location

  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
  app_settings               = { 
    "WEBSITE_RUN_FROM_PACKAGE" = "",
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
    }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"], # prevent TF reporting configuration drift after app code is deployed
    ]
  }

  site_config {
    application_insights_connection_string = azurerm_application_insights.application_insights.connection_string
    application_insights_key = azurerm_application_insights.application_insights.instrumentation_key
    cors {
      allowed_origins = var.allowed_origins
    }
  }

  depends_on = [azurerm_service_plan.service_plan]
}

#################################
## END function app SPECIFIC CODE
#################################

resource "azurerm_dns_cname_record" "cname_record_api" {
  name                = "api-${var.environment_key}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.core_resource_group_name
  ttl                 = 60
  record              = azurerm_windows_function_app.function_app.default_hostname

  depends_on = [azurerm_windows_function_app.function_app]
}

resource "azurerm_dns_txt_record" "txt_record_api" {
  name                = "asuid.${azurerm_dns_cname_record.cname_record_api.name}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.core_resource_group_name
  ttl                 = 60
  record {
    value = azurerm_windows_function_app.function_app.custom_domain_verification_id
  }

  depends_on = [azurerm_windows_function_app.function_app]  
}

  resource "azurerm_app_service_custom_hostname_binding" "hostname_binding" {
  hostname            = trim(azurerm_dns_cname_record.cname_record_api.fqdn, ".")
  app_service_name    = azurerm_windows_function_app.function_app.name
  resource_group_name = module.resource_group.name

  # Ignore ssl_state and thumbprint as they are managed using
  # azurerm_app_service_certificate_binding.example
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }

    timeouts {
    create = "30m"
    delete = "30m"
  }

    depends_on = [azurerm_windows_function_app.function_app]
}

resource "azurerm_app_service_managed_certificate" "managed_certificate" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname_binding.id

  depends_on = [azurerm_app_service_custom_hostname_binding.hostname_binding]
}

resource "azurerm_app_service_certificate_binding" "certificate_binding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname_binding.id
  certificate_id      = azurerm_app_service_managed_certificate.managed_certificate.id
  ssl_state           = "SniEnabled"

  depends_on = [azurerm_app_service_managed_certificate.managed_certificate]
} 