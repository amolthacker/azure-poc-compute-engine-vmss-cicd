provider "azurerm" {
  skip_provider_registration = "true"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_devops}"
  location = "${var.location}"
}

resource "azurerm_storage_account" "storage" {
  name                = "${var.storage_account_devops}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  location     = "${var.location}"
  account_type = "${var.storage_account_devops_sku}"
}