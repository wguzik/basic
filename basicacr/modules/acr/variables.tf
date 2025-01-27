variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where ACR will be created"
}

variable "sku" {
  type        = string
  description = "The SKU name of the container registry"
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be one of: Basic, Standard, Premium"
  }
}

variable "admin_enabled" {
  type        = bool
  description = "Enable admin user for the container registry"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to resources"
  default     = {}
} 

variable "kv_id" {
  type        = string
  description = "ID of the Key Vault"
}