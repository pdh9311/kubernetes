#!/bin/bash

echo -e "\033[96m./run [last_ip_bit]\033[0m"
if [ $# -ne 0 ]; then
	./docker.sh
	./static_ip.sh $1
	sudo chmod 777 /var/run/docker.sock
fi
