#!/bin/bash

# Добавление пользователя net_admin с UID 1010
useradd net_admin -u 1010 -U

# Установка пароля для пользователя net_admin
echo "net_admin:P@$$word" | chpasswd

# Добавление пользователя в группу wheel (если необходимо)
usermod -aG wheel net_admin

# Добавление строки в /etc/sudoers
# Используем echo и tee для добавления строки в конец файла
echo "net_admin ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

# Вывод сообщения об успешном завершении
echo "Пользователь net_admin успешно добавлен и настроен."

hostnamectl set-hostname br-rtr.au-team.irpo

mkdir -p /etc/net/ifaces/ens19
mkdir -p /etc/net/ifaces/gre1

echo "192.168.3.1/27" > /etc/net/ifaces/ens19/ipv4address

echo "TYPE=eth" > /etc/net/ifaces/ens19/options

echo -e "search au-team.irpo \nnameserver 192.168.1.10" > /etc/net/ifaces/ens19/resolv.conf

echo "10.10.0.2/30" > /etc/net/ifaces/gre1/ipv4address

echo -e "TYPE=iptun \nTUNTYPE=gre \nTUNLOCAL=172.16.5.5 \nTUNREMOTE=172.16.4.4 \nTUNTTL=64 \nTUNOPTIONS='ttl 64' \nDISABLE=no " > /etc/net/ifaces/gre1/options

echo -e "search au-team.irpo \nnameserver 192.168.1.10" > /etc/net/ifaces/gre1/resolv.conf

systemctl restart network

exec bash