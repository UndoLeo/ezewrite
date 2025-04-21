#!/bin/bash
# Установка зависимостей
apt-get update -y
apt-get install -y apache2 php8.2 mariadb-server \
php8.2-opcache php8.2-curl php8.2-gd php8.2-intl \
php8.2-mysqli php8.2-xml php8.2-xmlrpc php8.2-ldap \
php8.2-zip php8.2-soap php8.2-mbstring php8.2-json \
php8.2-xmlreader php8.2-fileinfo php8.2-sodium

# Настройка MySQL
mysql_secure_installation <<EOF

Y
P@ssw0rd
Y
Y
Y
Y
EOF

# Создание БД Moodle
mysql -u root -pP@ssw0rd <<MYSQL_SCRIPT
CREATE DATABASE moodledb;
CREATE USER 'moodle'@'localhost' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL PRIVILEGES ON moodledb.* TO 'moodle'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Установка Moodle
curl -L https://github.com/moodle/moodle/archive/refs/tags/v4.5.0.zip -o /root/moodle.zip
unzip /root/moodle.zip -d /var/www/html
mv /var/www/html/moodle-4.5.0/* /var/www/html/
rm -rf /var/www/html/moodle-4.5.0

# Настройка прав
mkdir /var/www/moodledata
chown -R www-data:www-data /var/www/html
chown www-data:www-data /var/www/moodledata

# Настройка PHP
sed -i 's/^max_input_vars = .*/max_input_vars = 5000/' /etc/php/8.2/apache2/php.ini

# Удаление стандартной страницы Apache
rm /var/www/html/index.html

# Перезапуск сервисов
systemctl enable --now apache2 mariadb
systemctl restart apache2

echo "Moodle установлен и доступен по http://192.168.1.2/install.php"