terraform {
  required_version = ">=1.6.0"
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.14" # use a última compatível (confira https://registry.terraform.io/providers/Telmate/proxmox/latest)
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://10.0.2.11:8006/api2/json"
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true              # true para laboratório (ambiente de produção, use certificado válido!)
}
