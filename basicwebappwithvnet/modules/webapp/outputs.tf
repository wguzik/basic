output "webapp_url" {
  description = "The URL of the web app"
  value       = "https://${azurerm_linux_web_app.webapp.default_hostname}"
}

output "webapp_principal_id" {
  description = "Principal ID of the web app's system-assigned managed identity"
  value       = azurerm_linux_web_app.webapp.identity[0].principal_id
}
