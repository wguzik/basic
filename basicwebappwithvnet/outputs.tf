output "webapp_url" {
  description = "The URL of the web app"
  value       = module.webapp.webapp_url
}

output "webapp_name" {
  description = "Name of the web app (needed for az webapp deploy)"
  value       = module.webapp.webapp_name
}

output "rg_name" {
  description = "Resource group name"
  value       = module.resource_group.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

output "storage_primary_blob_endpoint" {
  description = "Primary blob endpoint (accessible only via private endpoint)"
  value       = module.storage.primary_blob_endpoint
}
