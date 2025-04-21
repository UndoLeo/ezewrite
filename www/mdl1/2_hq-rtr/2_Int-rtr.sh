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


hostnamectl set-hostname hq-rtr.au-team.irpo

mkdir -p /etc/net/ifaces/ens19
mkdir -p /etc/net/ifaces/gre1
mkdir -p /etc/net/ifaces/vlan100
mkdir -p /etc/net/ifaces/vlan200
mkdir -p /etc/net/ifaces/vlan999



echo -e "BOOTPROTO=static \nTYPE=eth" > /etc/net/ifaces/ens19/options


echo "10.10.0.1/30" > /etc/net/ifaces/gre1/ipv4address 

echo -e "TYPE=iptun \nTUNTYPE=gre \nTUNLOCAL=172.16.4.4 \nTUNREMOTE=172.16.5.5 \nTUNTTL=64 \nTUNOPTIONS='ttl 64' \nDISABLE=no' " > /etc/net/ifaces/gre1/options

echo 192.168.1.1/26 > /etc/net/ifaces/vlan100/ipv4address 

echo -e "TYPE=vlan \nHOST=ens19 \nVID=100" > /etc/net/ifaces/vlan100/options

echo -e "search au-team.irpo \nnameserver 192.168.1.10" > /etc/net/ifaces/vlan100/resolv.conf

echo 192.168.2.1/28 > /etc/net/ifaces/vlan200/ipv4address 

echo -e "TYPE=vlan \nHOST=ens19 \nVID=200" > /etc/net/ifaces/vlan200/options

echo 192.168.99.1/28 > /etc/net/ifaces/vlan999/ipv4address 

echo -e "TYPE=vlan \nHOST=ens19 \nVID=999" > /etc/net/ifaces/vlan999/options


systemctl restart network


# Установка dnsmasq
apt-get install -y dnsmasq


# Внесение настроек в конфигурационный файл
{
    echo "port=0"
    echo "interface=vlan200"
    echo "listen-address=192.168.2.1"
    echo "dhcp-authoritative"
    echo "dhcp-range=interface:vlan200,192.168.2.2,192.168.2.14,255.255.255.240,6h"
    echo "dhcp-host=id:01:11:11:11:11:11:11,192.168.2.10"
    echo "dhcp-option=6,192.168.1.10"
    echo "leasefile-ro"
} > /etc/dnsmasq.conf

#запуск службы
systemctl enable dnsmasq --now


exec bash