output "access_key" {
  value       = azurerm_storage_account.storage_account.primary_access_key
  description = "The primary access key for the Storage Account."
  sensitive   = true
}

output "name" {
  value       = azurerm_storage_account.storage_account.name
  description = "The name of the Storage Account."
}
