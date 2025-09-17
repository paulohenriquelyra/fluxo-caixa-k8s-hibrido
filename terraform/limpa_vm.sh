# 1. Atualiza o sistema e instala pacotes essenciais
sudo apt update && sudo apt upgrade -y
sudo apt install -y qemu-guest-agent cloud-init

# 2. Habilita e inicia o QEMU Guest Agent
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent

# 3. Limpa o cloud-init para a próxima inicialização
sudo cloud-init clean --logs --seed

# 4. Remove identificadores únicos da máquina
sudo truncate -s 0 /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id

# 5. (Recomendado) Remove as chaves SSH do host para que sejam regeneradas no clone
sudo rm -f /etc/ssh/ssh_host_*

# 6. Limpa o histórico do terminal
history -c
history -w
sudo truncate -s 0 ~/.bash_history

# 7. Desliga a VM para conversão em template
sudo shutdown now
