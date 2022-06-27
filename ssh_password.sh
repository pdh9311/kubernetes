#!/bin/bash

ROOT_PW=qwe123
echo "root:$ROOT_PW" | chpasswd

## ssh password 접속 활성화
sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config