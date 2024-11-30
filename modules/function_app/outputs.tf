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