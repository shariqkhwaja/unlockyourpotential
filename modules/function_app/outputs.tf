output "default_hostname" {
  value       = azurerm_windows_function_app.function_app.default_hostname
  description = "The function app default hostname."
}

output "name" {
  value       = azurerm_windows_function_app.function_app.name
  description = "The function app name."
}

output "custom_domain_verification_id" {
  value       = azurerm_windows_function_app.function_app.custom_domain_verification_id
  description = "The function app custom_domain_verification_id."
}

output "storage_account_name" {
  value       = azurerm_storage_account.storage_account.name
  description = "The function app storage account name."
}

output "storage_account_primary_access_key" {
  value       = azurerm_storage_account.storage_account.primary_access_key
  description = "The function app storage account primary access key."
}

output "service_plan_id" {
  value       = azurerm_service_plan.service_plan.id
  description = "The function app service plan ID."
}

output "application_insights_connection_string" {
  value       = azurerm_application_insights.application_insights.connection_string
  description = "The application insights connection string."
}

output "application_insights_instrumentation_key" {
  value       = azurerm_application_insights.application_insights.instrumentation_key
  description = "The application insights instrumentation key."
}
