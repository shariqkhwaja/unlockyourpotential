resource "azurerm_dns_cname_record" "cname_record" {
  resource_group_name = var.dns_zone_resource_group_name
  zone_name           = var.dns_zone_name
  name                = var.website_cname_name
  record              = var.website_cname_record  
  ttl                 = 60  
  lifecycle {
    ignore_changes = [record]
  }
}

# resource "azurerm_dns_a_record" "a_record" {
#   count               = var.create_a_record ? 1 : 0
#   name                = "@"
#   zone_name           = var.zone_name
#   resource_group_name = var.resource_group_name
#   ttl                 = var.ttl
#   target_resource_id  = var.a_record_target_resource_id
# }

# resource "azurerm_dns_txt_record" "txt_record" {
#   count               = var.create_txt_record ? 1 : 0
#   name                = var.txt_name
#   zone_name           = var.zone_name
#   resource_group_name = var.resource_group_name
#   ttl                 = var.ttl
#   record {
#     value = var.txt_value
#   }
# }
