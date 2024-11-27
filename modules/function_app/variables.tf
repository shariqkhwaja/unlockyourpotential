variable "service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resources."
  type        = string
}

variable "function_app_name" {
  description = "The name of the Function App."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the associated Storage Account."
  type        = string
}

variable "storage_account_access_key" {
  description = "The access key for the associated Storage Account."
  type        = string
}

variable "application_insights_connection_string" {
  description = "Connection string for Application Insights."
  type        = string
}

variable "application_insights_key" {
  description = "Instrumentation key for Application Insights."
  type        = string
}

variable "allowed_origins" {
  description = "CORS allowed origins."
  type        = list(string)
}
