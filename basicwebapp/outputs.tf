output "webapp_url" {
  description = "The URL of the web app"
  value       = module.webapp.webapp_url
}

output "rg_name" {
  description = "Resource group name"
  value       = module.resource_group.name
}
