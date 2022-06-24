# kubernetes

아래 스크립트 실행전해야할 것.
1. VirtualBox의 NAT 네트워크추가 및 포트포워딩 설정
2. VirtualBox에 ubuntu 설치
3. root 환경에서
	apt update && apt upgrade -y && apt install -y git
	git clone https://github.com/pdh9311/kubernetes.git
	git config --global user.name "pdh9311"
	git config --global user.email "padohy@gmail.com"
4. ./docker.sh 스크립트 실행
5. ./static_ip.sh 스크립트 실행
6. ssh로 접속해서 사용.
