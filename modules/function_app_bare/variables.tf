variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resources."
  type        = string
}

variable "application_key" {
  description = "The application key."
  type        = string
}

variable "rest_api_names" {
  description = "The names of the REST APIs for the function apps."
  type        = list(string)
}


variable "environment_key" {
  description = "The environment key."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
}

variable "storage_account_primary_access_key" {
  description = "The access key for the storage account."
  type        = string
}

variable "service_plan_id" {
  description = "The ID of the app service plan."
  type        = string
}

variable "application_insights_connection_string" {
  description = "The connection string for the application insights."
  type        = string
}

variable "application_insights_instrumentation_key" {
  description = "The instrumentation key for the application insights."
  type        = string
} 