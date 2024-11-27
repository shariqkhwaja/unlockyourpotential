output "connection_string" {
  value       = azurerm_application_insights.application_insights.connection_string
  description = "The connection string for the Application Insights resource."
}

output "instrumentation_key" {
  value       = azurerm_application_insights.application_insights.instrumentation_key
  description = "The instrumentation key for the Application Insights resource."
}
