resource "azurerm_key_vault_secret" "acr_admin_username" {
  name         = "${var.acr_name}-admin-username"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = var.kv_id
}

resource "azurerm_key_vault_secret" "acr_admin_password" {
  name         = "${var.acr_name}-admin-password"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = var.kv_id
} 