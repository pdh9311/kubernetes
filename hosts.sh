#!/bin/bash

# Hosts 등록
cat << EOF >> /etc/hosts
10.0.2.56 k8s-master
10.0.2.57 k8s-node1
10.0.2.58 k8s-node2
EOF