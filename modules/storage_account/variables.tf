variable "storage_account_name" {
  description = "The name of the Storage Account."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Storage Account will be created."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the Storage Account."
  type        = string
}
