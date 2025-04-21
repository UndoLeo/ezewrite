#!/bin/bash
# Настройка NAT правил
iptables -t nat -A PREROUTING -p tcp -d 192.168.1.1 --dport 2024 -j DNAT --to-destination 192.168.1.2:2024

# Сохранение правил
iptables-save > /root/rules
echo "Правила NAT сохранены в /root/rules"