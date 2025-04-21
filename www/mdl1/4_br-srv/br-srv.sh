#!/bin/bash

#!/bin/bash

# Добавление пользователя sshuser с UID 1010 и созданием группы
useradd sshuser -u 1010 -U

# Установка пароля для пользователя sshuser
echo "sshuser:P@ssw0rd" | chpasswd

# Добавление пользователя в группу wheel
usermod -aG wheel sshuser

# Добавление строки в /etc/sudoers
# Используем echo и tee для добавления строки в конец файла
echo "sshuser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

# Вывод сообщения об успешном завершении
echo "Пользователь sshuser успешно добавлен и настроен."

# Установка временной зоны
timedatectl set-timezone Asia/Vladivostok

# Установка hostname и обновление текущей сессии
hostnamectl set-hostname br-srv.au-team.irpo
exec bash

# Настройка сети (статический IP)
echo -e "BOOTPROTO=static \nTYPE=eth" > /etc/net/ifaces/ens18/options
echo "192.168.3.10/27" > /etc/net/ifaces/ens18/ipv4address
echo "default via 192.168.3.1" > /etc/net/ifaces/ens18/ipv4route

# Перезапуск сети
systemctl restart network