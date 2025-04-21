#!/bin/bash

# Обновление и установка chrony
apt update -y
apt install -y chrony

# Настройка конфигурации chrony
cat > /etc/chrony/chrony.conf <<EOF
server 0.ru.pool.ntp.org iburst
server 1.ru.pool.ntp.org iburst
server 2.ru.pool.ntp.org iburst
server 3.ru.pool.ntp.org iburst

local stratum 5
allow 192.168.1.0/26
allow 192.168.2.0/28
allow 172.16.5.0/28
allow 192.168.4.0/27

keyfile /etc/chrony/chrony.keys
driftfile /var/lib/chrony/chrony.drift
logdir /var/log/chrony
maxupdateskew 100.0
makestep 1.0 3
rtcsync
EOF

# Перезапуск и настройка службы
systemctl enable --now chrony
systemctl restart chrony
timedatectl set-ntp 0
timedatectl