variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to resources"
  default     = {}
} 