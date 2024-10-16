output "webapp_url" {
  description = "The URL of the web app"
  value       = "https://${azurerm_linux_web_app.webapp.default_hostname}"
}
