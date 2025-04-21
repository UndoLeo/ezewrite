#!/bin/bash

# Очистка старых NTP служб
apt purge -y ntp chrony 2>/dev/null

# Установка systemd-timesyncd
apt update -y
apt install -y systemd-timesyncd

# Настройка NTP сервера
cat > /etc/systemd/timesyncd.conf <<EOF
[Time]
NTP=172.16.4.2
FallbackNTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
EOF

# Включение службы
systemctl enable --now systemd-timesyncd
timedatectl