#!/bin/bash

# Обновление списка пакетов
apt-get update

# Установка dnsmasq
apt-get install -y dnsmasq

# Включение и запуск dnsmasq
systemctl enable --now dnsmasq

# Настройка файла /etc/dnsmasq.conf
{
echo "no-resolv"
echo "no-poll"
echo "no-hosts"
echo "listen-address=192.168.1.10"
echo "server=77.88.8.8"
echo "server=195.208.4.1"
echo "server=195.208.5.1"
echo "server=8.8.8.8"
echo "cache-size=1000"
echo "all-servers"
echo "no-negcache"
echo "host-record=hq-rtr.au-team.irpo,192.168.1.1"
echo "host-record=hq-srv.au-team.irpo,192.168.1.10"
echo "host-record=hq-cli.au-team.irpo,192.168.2.10"
echo "address=/br-rtr.au-team.irpo/192.168.3.1"
echo "address=/br-srv.au-team.irpo/192.168.3.10"
echo "cname=moodle.au-team.irpo,hq-rtr.au-team.irpo"
echo "cname=wiki.au-team.irpo,hq-rtr.au-team.irpo"
} > /etc/dnsmasq.conf

# Настройка файла /etc/resolv.conf
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# Настройка файла /etc/hosts
echo "192.168.1.10 hq-rtr.au-team.irpo" >> /etc/hosts

# Перезапуск службы dnsmasq
systemctl restart dnsmasq