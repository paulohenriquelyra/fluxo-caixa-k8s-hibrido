// Terraform config placeholder
resource "proxmox_vm_qemu" "docker_vm" {
  name        = "docker-lab"
  target_node = "pve01"       # Ex: pve1, pve-node, etc (exatamente como aparece na UI)
  clone       = "docker-node01"        # Nome do template, não VMID!
  full_clone  = true                   # Recomenda-se sempre full_clone para VMs independentes
  
  # Hardware
  cores       = 2
  sockets     = 1
  memory      = 4096

  # Storage
  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "20G"
  }

  # Networking
  network {
    model   = "virtio"
    bridge  = "vmbr0"
  }

  # Cloud-init
  ciuser  = "ubuntu"
  cipassword = "senhaUsuario"
  sshkeys    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbuu0W4QaQPS0Gmm6mtZelE7Fs6eVTjTcFc0Q6ngwAI paulo.lyra@gmail.com"
  # Para instalar Docker automaticamente, use ciuser e cloud-init:
  # Em `cicommands`, coloque o script de instalação:
}
