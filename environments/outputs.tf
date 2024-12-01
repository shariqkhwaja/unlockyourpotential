# output "validation_token" {
#   value     = var.environment_key == "prd" ? module.static_website.static_web_app_custom_domain_apex[0].validation_token : null
#   sensitive = true
#   description = "The validation token for the custom domain in production."
# }
