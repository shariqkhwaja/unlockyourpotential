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
  app_settings = {
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
    application_insights_key               = azurerm_application_insights.application_insights.instrumentation_key
    cors {
      allowed_origins = ["http://localhost:8080", "https://dev.${var.dns_zone_name}", "https://stg.${var.dns_zone_name}", "https://${var.dns_zone_name}"]
    }
  }
}

resource "azurerm_dns_cname_record" "cname_record_api" {
  count               = var.environment_key != "prd" ? 1 : 0
  name                = "api-${var.environment_key}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 60
  record              = azurerm_windows_function_app.function_app.default_hostname

  depends_on = [azurerm_windows_function_app.function_app]
}

resource "azurerm_dns_txt_record" "txt_record_api" {
  count               = var.environment_key != "prd" ? 1 : 0
  name                = "asuid.${azurerm_dns_cname_record.cname_record_api[0].name}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 60
  record {
    value = azurerm_windows_function_app.function_app.custom_domain_verification_id
  }

  depends_on = [azurerm_windows_function_app.function_app]
}

resource "azurerm_app_service_custom_hostname_binding" "hostname_binding" {
  count               = var.environment_key != "prd" ? 1 : 0
  hostname            = trim(azurerm_dns_cname_record.cname_record_api[0].fqdn, ".")
  app_service_name    = azurerm_windows_function_app.function_app.name
  resource_group_name = var.resource_group_name

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
  count               = var.environment_key != "prd" ? 1 : 0
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname_binding[0].id

  depends_on = [azurerm_app_service_custom_hostname_binding.hostname_binding]
}

resource "azurerm_app_service_certificate_binding" "certificate_binding" {
  count               = var.environment_key != "prd" ? 1 : 0
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname_binding[0].id
  certificate_id      = azurerm_app_service_managed_certificate.managed_certificate[0].id
  ssl_state           = "SniEnabled"

  depends_on = [azurerm_app_service_managed_certificate.managed_certificate]
} 













resource "azurerm_dns_cname_record" "cname_record_api_prd" {
  count               = var.environment_key == "prd" ? 1 : 0
  name                = "api"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 60
  record              = azurerm_windows_function_app.function_app.default_hostname

  depends_on = [azurerm_windows_function_app.function_app]
}

resource "azurerm_dns_txt_record" "txt_record_api_prd" {
  count               = var.environment_key == "prd" ? 1 : 0
  name                = "asuid.${azurerm_dns_cname_record.cname_record_api_prd[0].name}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  ttl                 = 60
  record {
    value = azurerm_windows_function_app.function_app.custom_domain_verification_id
  }

  depends_on = [azurerm_windows_function_app.function_app]
}

resource "azurerm_app_service_custom_hostname_binding" "hostname_binding_prd" {
  count               = var.environment_key == "prd" ? 1 : 0
  hostname            = trim(azurerm_dns_cname_record.cname_record_api_prd[0].fqdn, ".")
  app_service_name    = azurerm_windows_function_app.function_app.name
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }

  timeouts {
    create = "30m"
    delete = "30m"
  }

  depends_on = [azurerm_windows_function_app.function_app]
}

resource "azurerm_app_service_managed_certificate" "managed_certificate_prd" {
  count               = var.environment_key == "prd" ? 1 : 0
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname_binding_prd[0].id

  depends_on = [azurerm_app_service_custom_hostname_binding.hostname_binding_prd]
}

resource "azurerm_app_service_certificate_binding" "certificate_binding_prd" {
  count               = var.environment_key == "prd" ? 1 : 0
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname_binding_prd[0].id
  certificate_id      = azurerm_app_service_managed_certificate.managed_certificate_prd[0].id
  ssl_state           = "SniEnabled"

  depends_on = [azurerm_app_service_managed_certificate.managed_certificate_prd]
} 












