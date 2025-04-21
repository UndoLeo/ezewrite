#!/bin/bash
# Configure DNS forwarding
echo "server=/au-team.irpo/192.168.4.2" >> /etc/dnsmasq.conf
systemctl restart dnsmasq
echo "DNS forwarding configured for au-team.irpo"