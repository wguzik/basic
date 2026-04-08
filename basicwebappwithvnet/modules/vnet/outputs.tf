output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "integration_subnet_id" {
  description = "Subnet ID for App Service VNet integration (delegated to Microsoft.Web/serverFarms)"
  value       = azurerm_subnet.integration.id
}

output "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoints"
  value       = azurerm_subnet.private_endpoints.id
}

output "private_dns_zone_blob_id" {
  description = "ID of the private DNS zone for blob storage"
  value       = azurerm_private_dns_zone.blob.id
}
