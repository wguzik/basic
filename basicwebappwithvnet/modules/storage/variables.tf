variable "name" {
  type        = string
  description = "Base name for storage resources"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet ID for the storage private endpoint"
}

variable "private_dns_zone_blob_id" {
  type        = string
  description = "ID of the private DNS zone for blob storage"
}
