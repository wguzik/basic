variable "name" {
  type        = string
  description = "Name of the Web App"
}

variable "location" {
  type        = string
  description = "Location of the Web App"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "sku_size" {
  type        = string
  description = "The SKU size for the App Service Plan"
}

variable "docker_image" {
  type        = string
  description = "The Docker image to be used for the Web App"
}

variable "docker_registry_url" {
  type        = string
  description = "URL of the container registry"
  default     = "https://index.docker.io"
}

variable "integration_subnet_id" {
  type        = string
  description = "Subnet ID for VNet integration (delegated to Microsoft.Web/serverFarms)"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account to be passed as an environment variable"
}
