#!/bin/bash

# Установка NFS клиента
apt-get update -y
apt-get install -y nfs-common

# Создание точки монтирования
mkdir -p /mnt/nfs

# Настройка автоматического монтирования
echo "192.168.1.2:/raid5/nfs /mnt/nfs nfs intr,soft,_netdev,x-systemd.automount 0 0" >> /etc/fstab

# Монтирование и проверка
mount -a
touch /mnt/nfs/test_file