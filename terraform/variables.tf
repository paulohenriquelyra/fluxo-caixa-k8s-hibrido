# Variáveis de conexão com o Proxmox
variable "proxmox_api_url" {
  type        = string
  description = "A URL da API do Proxmox (ex: https://10.0.2.11:8006/api2/json)."
}

variable "proxmox_user" {
  type        = string
  description = "O nome de usuário para autenticação na API do Proxmox (ex: demo@pve)."
}

variable "proxmox_password" {
  type        = string
  description = "A senha para autenticação na API do Proxmox."
  sensitive   = true
}

# Variáveis da VM
variable "vms" {
  type = map(object({
    name      = string
    cores     = number
    memory    = number
    disk_size = number
  }))
  description = "Um mapa de máquinas virtuais a serem criadas. A chave é um identificador lógico (ex: 'node1') e o valor contém os atributos da VM."
  default     = {}
}

variable "vm_node" {
  type        = string
  description = "O nó do Proxmox onde a VM será criada (ex: pve01)."
}

variable "vm_template_id" {
  type        = number
  description = "O VMID (número inteiro) do template de VM com cloud-init a ser clonado."
}

variable "vm_disk_storage" {
  type        = string
  description = "O storage do Proxmox para o disco da VM."
  default     = "local-lvm"
}

variable "vm_network_bridge" {
  type        = string
  description = "A bridge de rede a ser usada pela VM."
  default     = "vmbr0"
}

# Variáveis do Cloud-Init
variable "vm_user" {
  type        = string
  description = "O nome de usuário a ser criado na VM."
  default     = "paulo"
}

variable "vm_password" {
  type        = string
  description = "A senha para o usuário da VM."
  sensitive   = true
}

variable "vm_ssh_key" {
  type        = string
  description = "A chave pública SSH para ser adicionada ao usuário da VM."
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbuu0W4QaQPS0Gmm6mtZelE7Fs6eVTjTcFc0Q6ngwAI paulo.lyra@gmail.com"
}
