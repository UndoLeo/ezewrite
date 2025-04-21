#!/bin/bash

# Установка OpenSSH
apt-get update
apt-get install -y openssh-common

# Настройка конфигурационного файла sshd_config
{
    echo "Port 2024"
    echo "MaxAuthTries 2"
    echo "AllowUsers sshuser"
    echo "PermitRootLogin no"
    echo "Banner /root/banner"
} > /etc/openssh/sshd_config 

# Создание баннера
echo "Authorized access only" | tee /root/banner > /dev/null
echo "" | tee -a /root/banner > /dev/null  

# Включение и перезапуск службы SSH
systemctl enable --now sshd
systemctl restart sshd

# Вывод сообщения об успешном завершении
echo "SSH настроен и служба перезапущена."