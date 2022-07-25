data "azurerm_storage_account" "shared" {
  name                = "stweb${var.project}${var.environment}"
  resource_group_name = data.azurerm_resource_group.platform.name
}

resource "azurerm_storage_container" "web" {
  name                  = var.name
  storage_account_name  = data.azurerm_storage_account.shared.name
  container_access_type = "container"
}
