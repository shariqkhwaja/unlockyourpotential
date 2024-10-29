terraform {
  backend "azurerm" {
    # Empty backend configuration; actual configuration will be provided via CLI
  }
}

data "azurerm_client_config" "current" {}

module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "dns_zone" {
  source              = "./modules/dns_zone"
  resource_group_name = var.resource_group_name
  dns_zone_name           = var.dns_zone_name
  depends_on = [module.resource_group]
}

# resource "azurerm_dns_txt_record" "txt_record" {
#   name                = "@"
#   zone_name           = azurerm_dns_zone.dns_zone.name
#   resource_group_name = azurerm_resource_group.resource_group.name
#   ttl                 = 60

#   record {
#     value = "v=spf1 include:_spf.google.com ~all"
#   }
# }

# resource "azurerm_dns_txt_record" "txt_record_dkim" {
#   name                = "google._domainkey"
#   zone_name           = azurerm_dns_zone.dns_zone.name
#   resource_group_name = azurerm_resource_group.resource_group.name
#   ttl                 = 60

#   record {
#     value = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAk75YiuULlJNb4N7/YxpKDHipZofimNfy+RbHIFauf9S/lQZIiGNpEx49ICcxkCLhaxwUvq85/YiMN/FpkAKscBH1pHnvVpn/6DN+okNuIdqf7VGAFT8fP4/g8DxMZdvnmH92ciF8QyL4ZrnE2a/F7DtThPdGBfjFleXUTQBGB2kryxdBMX1X/ROwj72+iCkSaxWAAFfhNvxcgbUXgCUgcqDIkxhC8zZ1d9OjjUYIukxX4LyY9WYLu7CQASn0ytJCa9FTQ9b17psVFEpbc1JOr/RKKU5JzVDSre0yGnUXN4TID/nVNCVniARFkZxMafVvqFoUnqX8dZHyYTJEzbghcQIDAQAB"
#   }
# }

# // MX Records
# resource "azurerm_dns_mx_record" "mx_record" {
#   name                = "@"
#   resource_group_name = azurerm_resource_group.resource_group.name
#   zone_name           = var.dns_zone_name
#   ttl                 = 60

#   record {
#     preference = 1
#     exchange   = "ASPMX.L.GOOGLE.COM"
#   }

#   record {
#     preference = 5
#     exchange   = "ALT1.ASPMX.L.GOOGLE.COM"
#   }

#   record {
#     preference = 5
#     exchange   = "ALT2.ASPMX.L.GOOGLE.COM"
#   }

#     record {
#     preference = 10
#     exchange   = "ALT3.ASPMX.L.GOOGLE.COM"
#   }

#     record {
#     preference = 10
#     exchange   = "ALT4.ASPMX.L.GOOGLE.COM"
#   }

#   depends_on = [azurerm_dns_zone.dns_zone]  
# }

