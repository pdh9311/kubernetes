#!/bin/bash

# Swap disabled
CHECK_SWAP=$(free -h | grep "Swap" | awk '{print $2}')
if [ $CHECK_SWAP != "0B" ]; then
    echo -e "$CYAN Swap disabled $NC"
    swapoff -a && sed -i '/swap/s/^/#/' /etc/fstab
fi

# iptables가 브리지된 트래픽을 보게 하기
if [ ! -e /etc/modules-load.d/k8s.conf ]; then
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
fi
if [ ! -e /etc/sysctl.d/k8s.conf ]; then
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
fi
sysctl --system

 # (kubeadm, kubelet, kubectl) install
CHECK_KUBE=$(dpkg -l | grep kubectl | wc -l)
if [ $CHECK_KUBE -eq 0 ]; then
    echo -e "$CYAN (kubeadm, kubelet, kubectl) install $NC"
    apt-get update
    apt-get upgrade -y
    apt-get install -y apt-transport-https ca-certificates curl
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl
fi

if [ $HOSTNAME == "k8s-master" ]; then
sed -i '/.*disabled_plugins.*/s/^/#/g' /etc/containerd/config.toml
service containerd restart
kubeadm init | tail -e > token

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# weave
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
fi