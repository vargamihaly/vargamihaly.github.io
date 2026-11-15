locals {
  name_suffix = "${var.project}-${var.environment}"

  tags = merge({
    project    = var.project
    env        = var.environment
    managed-by = "terraform"
    repo       = "vargamihaly/vargamihaly.github.io"
  }, var.tags)
}

resource "azurerm_resource_group" "site" {
  name     = "rg-${local.name_suffix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_static_web_app" "site" {
  name                = "swa-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.site.name
  location            = azurerm_resource_group.site.location

  # The Free plan has no monthly charge.
  sku_tier = "Free"
  sku_size = "Free"

  tags = local.tags
}
