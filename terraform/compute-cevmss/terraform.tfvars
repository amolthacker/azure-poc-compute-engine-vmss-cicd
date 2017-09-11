location                    = "eastus2"

resource_group_devops       = "tds-devops"
storage_account_devops      = "tdsdevops"
storage_account_devops_sku  = "Standard_LRS"

resource_group_compute      = "tds-compute"
storage_account_compute     = "tdscompute"
storage_account_compute_sku = "Premium_LRS"

vmss_name                   = "cevmss"
vmss_instance_count         = "2"
vmss_vm_sku                 = "Standard_DS2_v2"
vmss_vm_admin_username      = "veritas"
vmss_vm_ssh_pubkey          = "ssh-rsa ... veritas@azure"

//vmss_vm_src_img_name        = "compute-engine-managed"