variable "custom_name" {
  type        = string
  description = "Custom name to be used for resource naming"
}

variable "region" {
  type        = string
  description = "Azure region to deploy resources"
}

variable "sku_size" {
  type        = string
  description = "The SKU size for the Web App"
}

variable "docker_image" {
  type        = string
  description = "The Docker image to be used for the Web App"
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID to use for the deployment"
}

