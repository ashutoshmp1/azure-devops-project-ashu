output "app_url" {
  value = "https://${azurerm_linux_web_app.app.name}.azurewebsites.net"
}

output "staging_url" {
  value = "https://${azurerm_linux_web_app.app.name}-staging.azurewebsites.net"
}