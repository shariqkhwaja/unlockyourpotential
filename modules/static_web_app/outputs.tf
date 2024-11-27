output "static_web_app_id" {
  value       = azurerm_static_web_app.static_web_app.id
  description = "The ID of the Static Web App."
}

output "default_host_name" {
  value       = azurerm_static_web_app.static_web_app.default_host_name
  description = "The default hostname for the Static Web App."
}