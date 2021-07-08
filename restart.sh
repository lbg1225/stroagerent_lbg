#!/bin/bash
kubectl delete svc,deploy,pod -n storagerent --all
kubectl delete ns storagerent
kubectl create ns storagerent
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
kubectl get deployment metrics-server -n kube-system
kubectl apply -f yml/kafkapod.yml
kubectl apply -f ./yml/siege.yml
kubectl apply -f yml/configmap.yml
./kubedeploy.sh v1
#./storage_autoscale.sh v1
#kubectl autoscale deploy storage -n storagerent --min=1 --max=10 --cpu-percent=15
#kubectl get all -n storagerent
#kubectl get deploy storage -w -n storagerent

