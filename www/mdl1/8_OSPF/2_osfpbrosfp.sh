#!/bin/bash

apt-get update
apt-get install -y frr

# Включение OSPF в конфигурации FRR
sed -i 's/ospfd=no/ospfd=yes/'g /etc/frr/daemons

# Перезапуск службы FRR
systemctl restart frr

# Настройка OSPF через vtysh
{
    echo "conf t"
    echo "router ospf"
    echo "network 10.10.0.0/30 area 0"
    echo "network 192.168.3.0/27 area 0"
    echo "exit"
    echo "int gre1"
    echo "ip ospf authentication message-digest"
    echo "ip ospf message-digest-key 1 md5 P@ssw0rd"
    echo "exit"
    echo "do wr mem"
} | vtysh