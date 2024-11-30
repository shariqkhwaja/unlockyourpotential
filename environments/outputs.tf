output "validation_token" {
  value = module.static_website.static_web_app_custom_domain_apex[0].validation_token
  sensitive = true
}