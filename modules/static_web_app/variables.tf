variable "name" {
  description = "The name of the Static Web App."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the Static Web App."
  type        = string
}

variable "location" {
  description = "The Azure region for the Static Web App."
  type        = string
}
