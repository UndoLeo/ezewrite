#!/bin/bash

# Установка имени хоста
hostnamectl set-hostname isp.au-team.irpo

# Создание директорий для интерфейсов
mkdir -p /etc/net/ifaces/ens19
mkdir -p /etc/net/ifaces/ens20

# Настройка интерфейса ens19
echo -e "BOOTPROTO=static\nTYPE=eth" > /etc/net/ifaces/ens19/options
echo 172.16.4.1/28 > /etc/net/ifaces/ens19/ipv4address 

# Настройка интерфейса ens20
echo -e "BOOTPROTO=static\nTYPE=eth" > /etc/net/ifaces/ens20/options
echo 172.16.5.1/28 > /etc/net/ifaces/ens20/ipv4address

# Перезапуск сетевой службы
systemctl restart network

# Включение IP-маршрутизации
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/net/sysctl.conf

# Установка iptables
apt-get install -y iptables

# Установка времени
apt-get install tzdata
timedatectl set-timezone Asia/Vladivostok

# Настройка NAT с помощью iptables
iptables -t nat -A POSTROUTING -s 172.16.4.0/28 -o ens18 -j MASQUERADE 
iptables -t nat -A POSTROUTING -s 172.16.5.0/28 -o ens18 -j MASQUERADE

# Сохранение правил iptables
iptables-save > /etc/sysconfig/iptables

# Автозапуск и перезапуск
systemctl enable iptables
systemctl restart iptables
service iptables enable


##
exec bash

reboot