variable "dns_zone_resource_group_name" {
  description = "The resource group where the DNS zone is located."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone."
  type        = string
}

variable "website_cname_name" {
  description = "The name of the CNAME record."
  type        = string
}

variable "website_cname_record" {
  description = "The value of the CNAME record."
  type        = string
}



# variable "create_a_record" {
#   description = "Flag to indicate if an A record should be created."
#   type        = bool
#   default     = false
# }

# variable "a_record_target_resource_id" {
#   description = "The target resource ID for the A record."
#   type        = string
# }

# variable "create_txt_record" {
#   description = "Flag to indicate if a TXT record should be created."
#   type        = bool
#   default     = false
# }

# variable "txt_name" {
#   description = "The name of the TXT record."
#   type        = string
# }

# variable "txt_value" {
#   description = "The value for the TXT record."
#   type        = string
# }
