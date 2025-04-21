#!/bin/bash

# Создание пользователя
useradd -m -u 1010 -s /bin/bash sshuser
echo "sshuser:P@ssw0rd" | chpasswd

# Настройка sudo
echo '%wheel ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers
usermod -aG wheel sshuser

# Установка SSH
apt-get install -y openssh-server python

# Настройка SSH
cat > /etc/ssh/sshd_config <<EOF
Port 2024
MaxAuthTries 2
AllowUsers sshuser
PermitRootLogin no
Banner /root/banner
EOF

echo "Authorized access only" > /root/banner
systemctl restart sshd
systemctl enable sshd