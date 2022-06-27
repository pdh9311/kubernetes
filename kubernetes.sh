#!/bin/bash

# Swap disabled
CHECK_SWAP=$(free -h | grep "Swap" | awk '{print $2}')
if [ $CHECK_SWAP != "0B" ]; then
    echo -e "$CYAN Swap disabled $NC"
    swapoff -a && sed -i '/swap/s/^/#/' /etc/fstab
fi

# iptables가 브리지된 트래픽을 보게 하기
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

 # (kubeadm, kubelet, kubectl) install
CHECK_KUBE=$(dpkg -l | grep kubectl | wc -l)
if [ $CHECK_KUBE -eq 0 ]; then
    echo -e "$CYAN (kubeadm, kubelet, kubectl) install $NC"
    apt update
    apt upgrade -y
    apt install -y apt-transport-https ca-certificates curl
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
    apt update
    apt install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl
fi

if [ $HOSTNAME == "k8s-master" ]; then
kubeadm init
fi