#!/bin/bash

# Создание RAID5
mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sd[b-d] --force

# Сохранение конфигурации RAID
mdadm --detail --scan >> /etc/mdadm.conf
update-initramfs -u

# Создание раздела и файловой системы
(
echo n  # Создать новый раздел
echo p  # Основной раздел
echo 1  # Номер раздела
echo    # Первый сектор по умолчанию
echo    # Последний сектор по умолчанию
echo w  # Записать изменения
) | fdisk /dev/md0

mkfs.ext4 /dev/md0p1

# Настройка монтирования
mkdir -p /raid5
echo "/dev/md0p1 /raid5 ext4 defaults 0 0" >> /etc/fstab
mount -a

# Установка и настройка NFS сервера
apt-get update -y
apt-get install -y nfs-kernel-server

mkdir -p /raid5/nfs
chown nobody:nogroup /raid5/nfs
chmod 777 /raid5/nfs

echo "/raid5/nfs 192.168.2.0/28(rw,sync,no_subtree_check)" >> /etc/exports

systemctl enable nfs-server
systemctl restart nfs-server
exportfs -a