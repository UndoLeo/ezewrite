#!/bin/bash
# Добавление репозитория
echo "deb [arch=amd64] http://repo.yandex.ru/yandex-browser/deb stable main" > /etc/apt/sources.list.d/yandex-browser.list

# Установка браузера
apt-get update -y
apt-get install -y yandex-browser-stable

echo "Яндекс Браузер установлен"