#!/bin/bash

# Color
MAGENTA="\033[95m"
NC="\033[0m"

# Static IP Setting
HOSTNAME=$(hostname)
CURRENT_IP=$(ip addr | grep "inet.*enp0s3" | awk '{print $2}')
IP_RANGE=$(echo `expr "$CURRENT_IP" : '\([0-9]*\.[0-9]*.[0-9]*.\)'`)
if [ $HOSTNAME == "k8s-master" ]; then
    IP_LAST_BIT="56"
elif [ $HOSTNAME == "k8s-node1" ]; then
    IP_LAST_BIT="57"
elif [ $HOSTNAME == "k8s-node2" ]; then
    IP_LAST_BIT="58"
else
    IP_LAST_BIT="error"
fi

if [ $IP_LAST_BIT != "error" ]; then
SUBNETMASK="/24"
IP=$IP_RANGE$IP_LAST_BIT$SUBNETMASK
GATEWAY=$IP_RANGE"1"
CHECK_STATIC_IP=$(cat /etc/netplan/00-installer-config.yaml | grep "addresses:" | wc -l)
if [ $CHECK_STATIC_IP -eq 0 ]; then
echo -e "$MAGENTA Static IP Setting $NC"
cat << EOF > /etc/netplan/00-installer-config.yaml
network:
  ethernets:
    enp0s3:
      dhcp4: false
      addresses: [$IP]
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4, $GATEWAY]
  version: 2
EOF
netplan apply
fi
STATIC_IP=$(ip addr | grep "inet.*enp0s3" | awk '{print $2}')
echo -e "$MAGENTA $STATIC_IP $NC"
fi