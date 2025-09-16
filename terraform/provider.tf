terraform {
  required_version = ">=1.6.0"
  required_providers {
    proxmox = {
      # Mudando para o provedor 'bpg/proxmox', que é mais moderno e compatível com Proxmox 8.x
      source  = "bpg/proxmox"
      version = ">= 0.40.2" # Usa a versão 0.40.2 ou a mais recente compatível
    }
  }
}

provider "proxmox" {
  endpoint                 = var.proxmox_api_url
  username                 = var.proxmox_user
  password                 = var.proxmox_password
  insecure                 = true # Apenas para laboratório. Em produção, use 'false' com um certificado válido.
}
