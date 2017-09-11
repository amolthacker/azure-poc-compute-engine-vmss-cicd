provider "azurerm" {
  skip_provider_registration = "true"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_compute}"
  location = "${var.location}"
}

/*
resource "azurerm_storage_account" "storage" {
  name                = "${var.storage_account_compute}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  location     = "${var.location}"
  account_type = "${var.storage_account_compute_sku}"
}
*/

resource "azurerm_template_deployment" "test" {
  name                = "ce-vmss-test"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  template_body = "${file("./azure-arm/cevmss-deploy.json")}"

  deployment_mode = "Incremental"

  parameters = {
    vmSku                     = "${var.vmss_vm_sku}"
    vmssName                  = "${var.vmss_name}"
    managedImageName          = "${var.vmss_vm_src_img_name}"
    managedImageResourceGroup = "${var.resource_group_devops}"
    adminUsername             = "${var.vmss_vm_admin_username}"
    sshPublicKey              = "${var.vmss_vm_ssh_pubkey}"
  }

}
