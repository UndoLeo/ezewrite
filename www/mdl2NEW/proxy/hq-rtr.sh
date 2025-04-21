#!/bin/bash
# Установка nginx
apt install -y nginx

# Создание конфига прокси
cat > /etc/nginx/sites-available/proxy <<EOF
server {
    listen 80;
    server_name moodle.au-team.irpo;

    location / {
        proxy_pass http://192.168.1.2:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
    }
}

server {
    listen 80;
    server_name wiki.au-team.irpo;

    location / {
        proxy_pass http://192.168.4.2:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$remote_addr;
    }
}
EOF

# Активация конфига
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/proxy /etc/nginx/sites-enabled/
systemctl restart nginx

echo "Обратный прокси настроен для:"
echo "- moodle.au-team.irpo -> 192.168.1.2:80"
echo "- wiki.au-team.irpo -> 192.168.4.2:8080"