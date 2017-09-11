variable "location" {
  type        = "string"
  default     = "eastus2"
  description = "Azure resources location"
}

variable "resource_group_devops" {
  type        = "string"
  default     = "tds-devops"
  description = "TDS Veritas DevOps RG"
}
variable "storage_account_devops" {
  type        = "string"
  default     = "tdsdevops"
  description = "TDS Veritas DevOps Storage Account"
}
variable "storage_account_devops_sku" {
  type        = "string"
  default     = "Standard_LRS"
  description = "TDS Veritas DevOps Storage Account SKU"
}

variable "resource_group_compute" {
  type        = "string"
  default     = "tds-compute"
  description = "TDS Veritas Compute RG"
}
variable "storage_account_compute" {
  type        = "string"
  default     = "tdscompute"
  description = "TDS Veritas Compute Storage Account"
}
variable "storage_account_compute_sku" {
  type        = "string"
  default     = "Premium LRS"
  description = "TDS Veritas Compute Storage Account SKU"
}

variable "vmss_name" {
  type        = "string"
  default     = "cevmss"
  description = "VMSS name"
}
variable "vmss_instance_count" {
  type        = "string"
  default     = "1"
  description = "VMSS instances"
}
variable "vmss_vm_sku" {
  type        = "string"
  default     = "Standard_DS2_v2"
  description = "VMSS VM SKU"
}
variable "vmss_vm_admin_username" {
  type        = "string"
  default     = "veritas"
  description = "VMSS VM admin username"
}
variable "vmss_vm_ssh_pubkey" {
  type        = "string"
  default     = "veritas"
  description = "VMSS VM SSH public key"
}

variable "vmss_vm_src_img_name" {
  type        = "string"
  default     = "compute-engine-managed"
  description = "Managed custom image name set by env variable TF_VAR_vmss_vm_src_img_name"
}
