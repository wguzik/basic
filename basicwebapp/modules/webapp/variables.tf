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
