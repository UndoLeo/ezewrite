#!/bin/bash

# Проверка наличия файла настроек
if [ -f "/home/sshuser/LocalSettings.php" ]; then
    mkdir -p /root/mediawiki
    mv /home/sshuser/LocalSettings.php /root/mediawiki/
    echo "Файл LocalSettings.php перемещен в /root/mediawiki/"
    
    # Обновление конфигурации docker-compose
    sed -i '/#volumes:/s/^#//' /root/wiki.yml
    sed -i '/volumes:/a \      - /root/mediawiki/LocalSettings.php:/var/www/html/LocalSettings.php' /root/wiki.yml
    
    # Перезапуск контейнеров
    docker compose -f /root/wiki.yml down
    docker compose -f /root/wiki.yml up -d
    echo "Контейнеры перезапущены с новыми настройками"
else
    echo "Файл LocalSettings.php не найден в /home/sshuser/"
fi