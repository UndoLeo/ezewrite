#!/bin/bash

# Обновление и установка SSH
apt-get update -y
apt-get install -y ssh-server

# Настройка SSH
cat > /etc/ssh/sshd_config <<EOF
Port 22
MaxAuthTries 2
AllowUsers net_admin
PermitRootLogin no
Banner /root/banner
EOF

# Создание баннера
echo "Authorized access only" > /root/banner

# Перезапуск SSH
systemctl restart sshd
systemctl enable sshd