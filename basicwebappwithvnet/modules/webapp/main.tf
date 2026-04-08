resource "azurerm_service_plan" "asp" {
  name                = "${var.name}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_size
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [azurerm_service_plan.asp]
  create_duration = "30s"
}

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_linux_web_app" "webapp" {
  depends_on          = [time_sleep.wait_30_seconds]
  name                = "${var.name}${random_string.random.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.asp.id

  virtual_network_subnet_id = var.integration_subnet_id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true

    application_stack {
      docker_image_name = var.docker_image
    }

    container_registry_use_managed_identity = false
  }

  app_settings = {
    "WEBSITE_VNET_ROUTE_ALL"   = "1"
    "STORAGE_ACCOUNT_NAME"     = var.storage_account_name
  }
}
