output "resource_group_name" {
  value = azurerm_resource_group.site.name
}

output "static_web_app_name" {
  value = azurerm_static_web_app.site.name
}

output "static_web_app_url" {
  description = "Default *.azurestaticapps.net URL of the site."
  value       = "https://${azurerm_static_web_app.site.default_host_name}"
}

output "static_web_app_api_key" {
  description = "Deployment token for Azure/static-web-apps-deploy. Read with: terraform output -raw static_web_app_api_key"
  value       = azurerm_static_web_app.site.api_key
  sensitive   = true
}
