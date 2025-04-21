#!/bin/bash

# Установка Docker и Docker Compose
apt-get update -y
apt-get install -y docker-engine docker-compose
systemctl enable --now docker

# Загрузка образов
docker pull mediawiki
docker pull mariadb

# Создание docker-compose файла
cat > /root/wiki.yml <<EOF
version: '3'
services:
  mariadb:
    image: mariadb
    container_name: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: P@ssw0rd
      MYSQL_DATABASE: mediawiki
      MYSQL_USER: wiki
      MYSQL_PASSWORD: P@ssw0rd
    volumes:
      - mariadb_data:/var/lib/mysql

  wiki:
    image: mediawiki
    container_name: wiki
    restart: always
    environment:
      MEDIAWIKI_DB_HOST: mariadb
      MEDIAWIKI_DB_USER: wiki
      MEDIAWIKI_DB_PASSWORD: P@ssw0rd
      MEDIAWIKI_DB_NAME: mediawiki
    ports:
      - "8080:80"
    depends_on:
      - mariadb

volumes:
  mariadb_data:
EOF

# Запуск контейнеров
docker compose -f /root/wiki.yml up -d

# Создание папки для настроек
mkdir -p /root/mediawiki
echo "MediaWiki успешно установлена и доступна на http://192.168.4.2:8080"