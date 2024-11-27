# output "default_host_name" {
#   value = azurerm_static_web_app.static_web_app.default_host_name
#   description = "The default host name for the Azure static web app."
#   sensitive = false
# }

# output "azure_static_web_app_api_key" {
#   value = azurerm_static_web_app.static_web_app.api_key
#   description = "The API key for the Azure static web app."
#   sensitive = true  # Mark this as sensitive if you don't want it to be displayed in logs
# }