output "function_app_default_hostname" {
  value       = azurerm_windows_function_app.function_app.default_hostname
  description = "The default hostname for the Function App."
}
