variable "azure_subscription_id" {
  default     = "5d0a772f-2d86-4fb5-8ecd-d19934a16dd8"
  description = "ID of the subscription."
}

variable "application_key" {
  default = "up"
  description = "The string in the resource name to denote the application."
}

variable "environment_key" {
  default = "dev"
  description = "The string in the resource name to denote the environment"
}

variable "dns_zone_resource_group_name" {
  default     = "rg-up-core"
  description = "Name of the core resource group ."
}

variable "dns_zone_name" {
  default     = "unlockyourpotential.ai"
  description = "Name of the DNS zone."
}

variable "resource_group_location" {
  default     = "australiasoutheast"
  description = "Location of the resource group."
}

variable "allowed_origins" {
  default = ["http://localhost:8080", "https://dev.unlockyourpotential.ai"]
}

variable "static_website_location" {
  default = "eastasia"
  description = "The Azure region for static web app."
}

