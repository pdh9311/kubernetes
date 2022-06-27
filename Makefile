master:
	ssh root@192.168.56.56
node1:
	ssh root@192.168.56.57
node2:
	ssh root@192.168.56.58

loop:
	for((;;)) do clear; kubectl get pod --all-namespaces; echo ""; kubectl get nodes; done

get-nodes:
	kubectl get nodes
get-nodes1:
	kubectl get nodes -o wide
pod-all:
	kubectl get pod --all-namespaces