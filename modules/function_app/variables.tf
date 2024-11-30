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

variable "environment_key" {
  description = "The environment key."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone."
  type        = string
}

variable "dns_zone_resource_group_name" {
  description = "The resource group where the DNS zone is located."
  type        = string
}