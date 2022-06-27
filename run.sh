#!/bin/bash

# Color
CYAN="\033[96m"
NC="\033[0m"

echo -e "$CYAN [ 1. ssh password ] $NC"
./ssh_password

echo -e "$CYAN [ 2. firewall ] $NC"
./firewall.sh

echo -e "$CYAN [ 4. hosts ] $NC"
./hosts.sh

echo -e "$CYAN [ 3. static ip ] $NC"
./static_ip.sh

echo -e "$CYAN [ 4. docker ] $NC"
./docker.sh

echo -e "$CYAN [ 5. kubernetes ] $NC"
./kubernetes.sh