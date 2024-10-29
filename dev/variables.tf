variable "azure_subscription_id" {
  default     = "5d0a772f-2d86-4fb5-8ecd-d19934a16dd8"
  description = "ID of the subscription."
}

variable "resource_group_name" {
  default     = "rg-up-dev"
  description = "Name of the resource group."
}

variable "resource_group_location" {
  default     = "australiasoutheast"
  description = "Location of the resource group."
}

variable "dns_zone_name" {
  default     = "unlockyourpotential.ai"
  description = "Name of the DNS zone."
}

variable "core_resource_group_name" {
  default     = "rg-up-core"
  description = "Name of the core resource group."
}

variable "storage_account_name" {
  default     = "saupdev"
  description = "Name of the storage account."
}

variable "static_web_app_name" {
  default     = "sw-up-dev"
  description = "Name of the static web app."
}

variable "domain_name" {
  default     = "unlockyourpotential.ai"
  description = "Name of the domain."
}



variable "allowed_origins" {
  default = ["http://localhost:8080", "https://dev.unlockyourpotential.ai"]
}

variable "application_key" {
  default = "up"
  description = "The string in the resource name to denote the application."
}

variable "static_website_location" {
  default = "eastasia"
  description = "The Azure region for static web app."
}

variable "environment_key" {
  default = "dev"
  description = "The string in the resource name to denote the environment"
}

