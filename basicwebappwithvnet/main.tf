module "resource_group" {
  source   = "./modules/resource_group"
  name     = "${var.custom_name}-rg"
  location = var.region
}

module "vnet" {
  source              = "./modules/vnet"
  name                = var.custom_name
  location            = var.region
  resource_group_name = module.resource_group.name
  depends_on          = [module.resource_group]
}

module "storage" {
  source                     = "./modules/storage"
  name                       = "${var.custom_name}st"
  location                   = var.region
  resource_group_name        = module.resource_group.name
  private_endpoint_subnet_id = module.vnet.private_endpoint_subnet_id
  private_dns_zone_blob_id   = module.vnet.private_dns_zone_blob_id
  depends_on                 = [module.vnet]
}

module "webapp" {
  source                = "./modules/webapp"
  name                  = "${var.custom_name}-webapp"
  resource_group_name   = module.resource_group.name
  location              = var.region
  sku_size              = var.sku_size
  integration_subnet_id = module.vnet.integration_subnet_id
  storage_account_name  = module.storage.storage_account_name
  depends_on            = [module.resource_group, module.vnet, module.storage]
}

resource "azurerm_role_assignment" "webapp_storage_blob_reader" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = module.webapp.webapp_principal_id
  depends_on           = [module.webapp, module.storage]
}
