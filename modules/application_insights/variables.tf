variable "application_insights_name" {
  description = "The name of the Application Insights resource."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the Application Insights resource."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where Application Insights will be created."
  type        = string
}
