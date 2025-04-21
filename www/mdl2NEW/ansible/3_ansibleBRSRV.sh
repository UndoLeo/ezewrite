#!/bin/bash

# Удаляем старый репозиторий и обновляем пакеты
apt-repo rm rpm http://altrepo.ru/local-p10 -y
apt-get update -y

# Устанавливаем Ansible
apt-get install -y ansible

# Автоматическая настройка inventory файла
echo "!!!!ПРОВЕРЬТЕ IP-АДРЕССА В ХОСТ ФАЙЛЕ!!!!"
cat > /etc/ansible/hosts <<EOF
[hq]
hq-srv ansible_host=sshuser@192.168.1.2 ansible_port=2024
hq-cli ansible_host=sshuser@192.168.2.5 ansible_port=2024

[routers]
hq-rtr ansible_host=net_admin@192.168.1.1 ansible_port=22
br-rtr ansible_host=net_admin@192.168.4.1 ansible_port=22
EOF

# Настройка конфига Ansible
mkdir -p /etc/ansible
cat > /etc/ansible/ansible.cfg <<EOF
[defaults]
interpreter_python=auto_silent
ansible_python_interpreter=/usr/bin/python3
host_key_checking = False
EOF

# Генерация SSH ключей и копирование на хосты
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# Функция для автоматического копирования ключа
function copy_key {
    sshpass -p 'P@ssw0rd' ssh-copy-id -o StrictHostKeyChecking=no -p $2 $1
}

copy_key net_admin@192.168.4.1 22
copy_key sshuser@192.168.2.11 2024
copy_key sshuser@192.168.1.2 2024
copy_key net_admin@192.168.1.1 22

# Проверка подключения
ansible all -m ping