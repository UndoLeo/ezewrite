#!/bin/bash

# Set DNS and install Samba AD DC
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apt-get update -y
apt-get install -y task-samba-dc
echo "nameserver 192.168.1.2" > /etc/resolv.conf

# Configure hostname and hosts
hostnamectl set-hostname br-srv.au-team.irpo
echo "192.168.4.2 br-srv.au-team.irpo" >> /etc/hosts

# Provision domain
samba-tool domain provision \
  --realm=AU-TEAM.IRPO \
  --domain=AU-TEAM \
  --server-role=dc \
  --dns-backend=SAMBA_INTERNAL \
  --host-ip=192.168.1.2 \
  --use-rfc2307 \
  --adminpass='P@ssw0rd' \
  --option="idmap_ldb:use rfc2307 = yes"

# Move Kerberos config
mv -f /var/lib/samba/private/krb5.conf /etc/

# Enable services
systemctl enable samba
(crontab -l 2>/dev/null; echo "@reboot /bin/systemctl restart network"; echo "@reboot /bin/systemctl restart samba") | crontab -

# Create users and groups
for i in {1..5}; do
  samba-tool user add user$i.hq P@ssw0rd
done
samba-tool group add hq
samba-tool group addmembers hq user1.hq,user2.hq,user3.hq,user4.hq,user5.hq

# Install sudo schema
apt-repo add rpm http://altrepo.ru/local-p10 noarch local-p10
apt-get update -y
apt-get install -y sudo-samba-schema

# Apply sudo schema
sudo-schema-apply <<EOF
yes
Administrator
P@ssw0rd
ok
EOF

# Create sudo rule
create-sudo-rule <<EOF
prava_hq
ALL
/bin/cat
%hq
EOF

# Import users from CSV
curl -L https://bit.ly/3C1nEYz > /root/users.zip
unzip /root/users.zip -d /root
mv /root/Users.csv /opt/

# Create import script
cat > /root/import <<'EOF'
#!/bin/bash
csv_file="/opt/Users.csv"
while IFS=";" read -r firstName lastName role phone ou street zip city country password; do
  if [ "$firstName" == "First Name" ]; then
    continue
  fi
  username="${firstName,,}.${lastName,,}"
  samba-tool user add "$username" 123qweR%
done < "$csv_file"
EOF

chmod +x /root/import
/root/import

echo "Domain controller setup complete! Please reboot."