output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value     = azurerm_key_vault_secret.acr_admin_username.name
  sensitive = true
}

output "acr_admin_password" {
  value     = azurerm_key_vault_secret.acr_admin_password.name
  sensitive = true
} 