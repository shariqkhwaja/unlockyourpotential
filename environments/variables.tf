variable "azure_subscription_id" {
  description = "ID of the subscription."
  type        = string
}

variable "application_key" {
  description = "The string in the resource name to denote the application."
  type        = string
}

variable "environment_key" {
  description = "The string in the resource name to denote the environment."
  type        = string
}

variable "dns_zone_name" {
  description = "Name of the DNS zone."
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group."
  type        = string
}

variable "core_resource_group_name" {
  description = "Location of the resource group."
  type        = string
}

variable "static_website_location" {
  description = "The Azure region for the static web app."
  type        = string
}
