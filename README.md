# kubernetes

1. VirtualBox의 NAT 네트워크추가 및 포트포워딩 설정 (mac의 경우 호스트 네트워크도 설정)
2. VirtualBox에 ubuntu 설치
3. root 환경에서 \
	apt update && apt upgrade -y && apt install -y git \
	git clone https://github.com/pdh9311/kubernetes.git 
4. ./run.sh \
	각 k8s-master, k8s-node1, k8s-node2에 대한 가상 머신에 적용한다.
7. ssh로 접속해서 사용.
