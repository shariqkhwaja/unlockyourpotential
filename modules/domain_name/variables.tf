variable "dns_zone_name" {
  description = "Name of the DNS zone."
}

variable "resource_group_location" {
  description = "Resource group location for the DNS zone."
}

variable "application_key" {
  description = "The application key."
  type        = string
}

variable "environment_key" {
  description = "The environment key."
  type        = string
}
