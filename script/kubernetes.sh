#!/bin/bash

# Color
MAGENTA="\033[95m"
NC="\033[0m"

# Swap disabled
CHECK_SWAP=$(free -h | grep "Swap" | awk '{print $2}')
if [ $CHECK_SWAP != "0B" ]; then
    echo -e "$MAGENTA Swap disabled $NC"
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
    echo -e "$MAGENTA (kubeadm, kubelet, kubectl) install $NC"
    apt-get update
    apt-get upgrade -y
    apt-get install -y apt-transport-https ca-certificates curl
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl
    sed -i '/.*disabled_plugins.*/s/^/#/g' /etc/containerd/config.toml
    service containerd restart
fi

if [ $HOSTNAME == "k8s-master" ]; then
echo -e "$MAGENTA kubeadm init ... $NC"
kubeadm init | tail -2 > $HOME/token

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
echo 'KUBECONFIG=/etc/kubernetes/admin.conf' > $HOME/.bashrc
source $HOME/.bashrc

echo -e "$MAGENTA weave $NC"
# weave
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl get nodes
fi