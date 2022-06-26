#!/bin/bash


echo -e "\033[96m./run [last_ip_bit]\033[0m"

## Docker install
DOCKER=$(docker version | grep "Docker Engine - Community" | wc -l)
if [ $DOCKER -eq 0 ]; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    chmod 777 /var/run/docker.sock
    rm -rf get-docker.sh
	chmod 777 /var/run/docker.sock
fi

## Kubernetes install
# Swap disabled
SWAP=$(free -h | grep "Swap" | awk '{print $2}')
if [ $SWAP -ne "0B" ]; then
	swapoff -a && sed -i '/swap/s/^/#/' /etc/fstab
fi

# kubeadm, kubelet, kubectl 설치
KUBE=$(dpkg -l | grep kubectl | wc -l)
if [ $KUBE -eq 0 ]; then
	apt update
	apt install -y apt-transport-https ca-certificates curl
	curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
	echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
	apt update
	apt install -y kubelet kubeadm kubectl
	apt-mark hold kubelet kubeadm kubectl
fi

## static ip setting
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