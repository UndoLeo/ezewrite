#!/bin/bash

#!/bin/bash

# Добавление пользователя sshuser с UID 1010 и созданием группы
useradd sshuser -u 1010 -U

# Установка пароля для пользователя sshuser
echo "sshuser:P@ssw0rd" | chpasswd

# Добавление пользователя в группу wheel
usermod -aG wheel sshuser

# Добавление строки в /etc/sudoers
# Используем echo и tee для добавления строки в конец файла
echo "sshuser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

# Вывод сообщения об успешном завершении
echo "Пользователь sshuser успешно добавлен и настроен."

# Set timezone to Vladivostok
timedatectl set-timezone Asia/Vladivostok

# Set hostname and refresh current session
hostnamectl set-hostname hq-srv.au-team.irpo
exec bash

# Configure network interface with static IP
echo -e "BOOTPROTO=static\nTYPE=eth" > /etc/net/ifaces/ens18/options
echo "192.168.1.10/26" > /etc/net/ifaces/ens18/ipv4address
echo "default via 192.168.1.1" > /etc/net/ifaces/ens18/ipv4route

# Set DNS server
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Restart network service
systemctl restart network

# Update package lists and install wget
apt-get update
apt-get install -y wget