resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

locals {
  rg_name = "rg-${var.project_name}-${var.environment}-${random_string.random.result}"
  kv_name = substr("kv-${var.project_name}-${var.environment}-${random_string.random.result}", 0, 24)
  acr_name = replace("acr-${var.project_name}-${var.environment}-${random_string.random.result}", "-", "")
}
