#!/bin/bash

## 방화벽 해제
systemctl stop firewalld && systemctl disabled firewalld
systemctl stop NetworkManager && systemctl disabled NetworkManager