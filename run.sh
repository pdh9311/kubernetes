#!/bin/bash

apt-get install -y make

# Color
CYAN="\033[96m"
NC="\033[0m"

echo -e "$CYAN [ 1. ssh password ] $NC"
./script/ssh_password.sh

echo -e "$CYAN [ 2. firewall ] $NC"
./script/firewall.sh

echo -e "$CYAN [ 4. hosts ] $NC"
./script/hosts.sh

echo -e "$CYAN [ 3. static ip ] $NC"
#./script/static_ip.sh
./script/mac_host_network.sh

echo -e "$CYAN [ 4. docker ] $NC"
./script/docker.sh

echo -e "$CYAN [ 5. kubernetes ] $NC"
./script/kubernetes.sh