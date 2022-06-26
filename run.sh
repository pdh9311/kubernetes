#!/bin/bash

echo -e "\033[96m./run [last_ip_bit]\033[0m"
if [ $# -ne 0 ]; then
	./docker.sh
	./static_ip.sh $1
	chmod 777 /var/run/docker.sock
fi

# Swap disabled
swapoff -a && sed -i '/swap/s/^/#/' /etc/fstab

# kubeadm, kubelet, kubectl 설치
apt update
apt install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl