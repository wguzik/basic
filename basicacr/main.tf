module "resource_group" {
  source = "./modules/resource_group"

  resource_group_name = local.rg_name
  location            = var.location

  tags = {
    environment = var.environment
    project     = var.project_name
  }
}

module "keyvault" {
  source = "./modules/keyvault"

  key_vault_name      = local.kv_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  tags = {
    environment = var.environment
    project     = var.project_name
  }
}

module "acr" {
  source = "./modules/acr"

  acr_name            = local.acr_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  sku                 = "Basic"
  admin_enabled       = true

  kv_id = module.keyvault.key_vault_id

  tags = {
    environment = var.environment
    project     = var.project_name
  }
}

