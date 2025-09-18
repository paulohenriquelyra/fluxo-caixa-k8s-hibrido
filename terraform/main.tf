# NOTA: Este arquivo de configuração cria uma VM clonando um template existente.
# Esta é a abordagem recomendada e padrão para automação com Terraform,
# pois a instalação de um sistema operacional a partir de um ISO é um processo
# interativo ou que exige automação complexa (autoinstall) que não é
# idealmente gerenciada pelo ciclo de vida do Terraform.
#
# Para que este código funcione, você deve primeiro ter um template de VM no Proxmox
# com o cloud-init instalado. Você pode criar um seguindo tutoriais online para
# "create ubuntu cloud-init template proxmox".

resource "proxmox_virtual_environment_vm" "ubuntu_server" {
  # Itera sobre o mapa de VMs definido em variables.tf
  for_each = var.vms

  name      = each.value.name
  node_name   = var.vm_node

  # Clona a partir de um template existente
  # O novo provedor usa um bloco 'clone' e requer o VMID (número) do template, não o nome.
  clone {
    vm_id   = var.vm_template_id
    full    = true # Recomendado para VMs independentes
  }

  # Agente QEMU para obter o IP e outras informações da VM
  agent {
    enabled = true
  }

  cpu {
    cores   = each.value.cores
    sockets = 1
    # 'host' passa as flags da CPU do host para a VM, melhorando a compatibilidade.
    type = "host"
  }

  memory {
    dedicated = each.value.memory
  }

  # Define o tipo de controladora SCSI. 'virtio-scsi-pci' é recomendado para templates modernos.
  scsi_hardware = "virtio-scsi-pci"

  disk {
    interface    = "scsi0"
    datastore_id = var.vm_disk_storage
    size         = each.value.disk_size
  }

  # Networking
  network_device {
    model  = "virtio"
    bridge = var.vm_network_bridge
  }

  operating_system {
    # Define o tipo de SO para o Proxmox. 'l26' é para kernels Linux modernos (2.6+).
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      username = var.vm_user
      password = var.vm_password
      keys     = [var.vm_ssh_key]
    }
  }
}

output "vm_ip_addresses" {
  description = "Um mapa com os endereços IP das máquinas virtuais criadas."
  value = {
    # Cria um mapa de saída com o nome da VM e seu respectivo IP
    for key, vm in proxmox_virtual_environment_vm.ubuntu_server :
    key => vm.ipv4_addresses[1][0]
    # Garante que só tentamos acessar o IP se o QEMU agent retornou a informação
    if length(vm.ipv4_addresses) > 1 && length(vm.ipv4_addresses[1]) > 0
  }
}
