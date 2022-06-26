#!/bin/bash

# static ip setting
# echo -e "\033[96m./static_ip.sh [ip_last_bit]\033[0m"

if [ $# -ne 0 ]; then
CURRENT_IP=$(ip addr | grep "inet.*enp0s3" | awk '{print $2}')
IP_RANGE=$(echo `expr "$CURRENT_IP" : '\([0-9]*\.[0-9]*.[0-9]*.\)'`)
IP_LAST_BIT=$1
SUBNETMASK="/24"
IP=$IP_RANGE$IP_LAST_BIT$SUBNETMASK
GATEWAY=$IP_RANGE"1"

echo "network:
  ethernets:
    enp0s3:
      dhcp4: false
      addresses: [$IP]
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4, $GATEWAY]
  version: 2" \
          > /etc/netplan/00-installer-config.yaml

netplan apply

fi
