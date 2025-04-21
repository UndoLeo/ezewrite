#!/bin/bash

# Отключение chrony
systemctl disable --now chronyd 2>/dev/null

# Установка systemd-timesyncd
apt-get update -y
apt-get install -y systemd-timesyncd

# Настройка NTP сервера
cat > /etc/systemd/timesyncd.conf <<EOF
[Time]
NTP=192.168.1.1
FallbackNTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
EOF

# Включение службы
systemctl enable --now systemd-timesyncd
timedatectl timesync-status