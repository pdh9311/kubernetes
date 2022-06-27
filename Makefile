run :
	./run.sh

master :
	ssh root@192.168.56.56
node1 :
	ssh root@192.168.56.57
node2 :
	ssh root@192.168.56.58

loop :
	bash ./make/check_join.sh

token :
	cat ~/token
nodes :
	kubectl get nodes
wide :
	kubectl get nodes -o wide
all :
	kubectl get pod --all-namespaces