output "acr_username" {
  value = module.acr.acr_admin_username
}

output "acr_password" {
  value = module.acr.acr_admin_password
}

output "kv_name" {
  value = module.keyvault.key_vault_name
}
