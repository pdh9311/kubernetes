#!/bin/bah

for((;;)) \
do \
    clear; \
    kubectl get pod --all-namespaces; \
    echo ''; \
    kubectl get nodes; \
    sleep 20; \
done