#!/bin/bash
# Install required packages
apt-get update -y
apt-get install -y admc sssd libnss-sss libpam-sss samba-common-bin

# Configure SSSD
cat > /etc/sssd/sssd.conf <<EOF
[sssd]
services = nss, pam, sudo
config_file_version = 2
domains = au-team.irpo

[domain/au-team.irpo]
id_provider = ad
access_provider = ad
sudo_provider = ad
auth_provider = ad
chpass_provider = ad
cache_credentials = True
krb5_realm = AU-TEAM.IRPO
realmd_tags = manages-system joined-with-samba 
default_shell = /bin/bash
ldap_id_mapping = True
fallback_homedir = /home/%u
EOF

chmod 600 /etc/sssd/sssd.conf

# Configure nsswitch
sed -i 's/^sudoers:.*/sudoers: files sss/' /etc/nsswitch.conf

# Join domain
echo "P@ssw0rd" | kinit administrator
realm join -U administrator au-team.irpo

# Clear cache and restart services
rm -rf /var/lib/sss/db/*
sss_cache -E
systemctl restart sssd

echo "Domain join complete! Please reboot."