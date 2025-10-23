#!/bin/bash
# Este script deve ser executado como root no shell do Proxmox.

set -e # Encerra o script imediatamente se um comando falhar.

# Este script cria um template de VM Ubuntu Cloud-Init limpo e pronto para uso.
# Ele usa a ferramenta 'virt-customize' para modificar a imagem de disco "offline",
# o que é um método mais robusto e confiável do que iniciar e limpar uma VM.

if [[ $EUID -ne 0 ]]; then
   echo "ERRO: Este script deve ser executado como root (ou com sudo)."
   exit 1
fi

VMID=9000
VM_NAME="ubuntu-2204-template"
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMAGE_FILE=$(basename "$IMAGE_URL")
STORAGE="local-lvm"

echo "--> Passo 1: Instalando dependências (libguestfs-tools)"
apt-get update
apt-get install -y libguestfs-tools

echo "--> Passo 2: Baixando a imagem oficial do Ubuntu Cloud"
cd /tmp
wget -nc "$IMAGE_URL"

echo "--> Passo 3: Customizando a imagem com virt-customize (isso pode levar alguns minutos)"
# Instala o agente qemu, limpa o cloud-init e zera o machine-id.
virt-customize -a "$IMAGE_FILE" \
  --install qemu-guest-agent \
  --run-command 'systemctl enable qemu-guest-agent' \
  --run-command 'cloud-init clean --logs --seed' \
  --run-command 'truncate -s 0 /etc/machine-id' \
  --run-command 'rm -f /var/lib/dbus/machine-id' \
  --run-command 'rm -f /etc/ssh/ssh_host_*' \
  --run-command 'userdel -r ubuntu || true' \
  --selinux-relabel

echo "--> Passo 4: Criando e configurando a VM no Proxmox"
qm destroy "$VMID" --destroy-unreferenced-disks 1 --purge || true
qm create "$VMID" --name "$VM_NAME" --cores 2 --memory 2048 \
  --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci --agent 1

echo "--> Passo 5: Importando o disco customizado para a VM"
qm importdisk "$VMID" "$IMAGE_FILE" "$STORAGE"

echo "--> Passo 6: Anexando o disco e configurando o boot"
qm set "$VMID" --scsi0 "${STORAGE}:vm-${VMID}-disk-0" --boot c --bootdisk scsi0

echo "--> Passo 7: Adicionando um drive Cloud-Init (necessário para o Terraform)"
qm set "$VMID" --ide2 "${STORAGE}:cloudinit"

echo "--> Passo 8: Convertendo a VM em um template"
qm template "$VMID"

echo "Template ${VM_NAME} (ID: ${VMID}) criado com sucesso."

echo "--> Passo 9: Limpando o arquivo de imagem baixado"
rm -f "/tmp/${IMAGE_FILE}"

echo "Certifique-se de que a variável 'vm_template_id' no seu terraform.tfvars está definida como ${VMID}."
