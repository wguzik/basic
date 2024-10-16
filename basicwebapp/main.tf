module "resource_group" {
  source   = "./modules/resource_group"
  name     = "${var.custom_name}-rg"
  location = var.region
}

module "webapp" {
  source              = "./modules/webapp"
  name                = "${var.custom_name}-webapp"
  resource_group_name = module.resource_group.name
  location            = var.region
  sku_size            = var.sku_size
  docker_image        = var.docker_image
  depends_on          = [module.resource_group]
}

