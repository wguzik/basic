variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region location"
  default     = "westeurope"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}
