variable "proxmox_user" {
  type        = string
  description = "usuario"
}

variable "proxmox_password" {
  type        = string
  description = "senha usuario"
  sensitive   = true
}
