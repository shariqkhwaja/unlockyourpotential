resource "azurerm_windows_function_app" "function_app" {
  for_each = toset(var.rest_api_names)

  name                = "fa-${var.application_key}-${each.key}-${var.environment_key}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_primary_access_key
  service_plan_id            = var.service_plan_id
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
    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_instrumentation_key
  }
}
