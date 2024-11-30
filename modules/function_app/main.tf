resource "azurerm_storage_account" "storage_account" {
  name                     = "sa${var.application_key}${var.environment_key}"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_application_insights" "application_insights" {
  name                = "ai-${var.application_key}-${var.environment_key}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "sp-${var.application_key}-${var.environment_key}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function_app" {
  name                = "fa-${var.application_key}-${var.environment_key}"
  resource_group_name = var.resource_group_name
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
}


resource "azurerm_dns_cname_record" "cname_record_api" {
  name                = "api-${var.environment_key}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 60
  record              = azurerm_windows_function_app.function_app.default_hostname

  depends_on = [ azurerm_windows_function_app.function_app ]
}

resource "azurerm_dns_txt_record" "txt_record_api" {
  name                = "asuid.${azurerm_dns_cname_record.cname_record_api.name}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 60
  record {
    value = azurerm_windows_function_app.function_app.custom_domain_verification_id
  }

  depends_on = [ azurerm_windows_function_app.function_app]  
}

  resource "azurerm_app_service_custom_hostname_binding" "hostname_binding" {
  hostname            = trim(azurerm_dns_cname_record.cname_record_api.fqdn, ".")
  app_service_name    = azurerm_windows_function_app.function_app.name
  resource_group_name = var.resource_group_name

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