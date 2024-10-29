variable "azure_subscription_id" {
  default     = "5d0a772f-2d86-4fb5-8ecd-d19934a16dd8"
  description = "ID of the subscription."
}

variable "resource_group_name" {
  default     = "rg-up-core"
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
