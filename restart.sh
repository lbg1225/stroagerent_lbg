#!/bin/bash
kubectl delete svc,deploy,pod -n storagerent --all
kubectl delete ns storagerent
kubectl create ns storagerent
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
kubectl get deployment metrics-server -n kube-system
kubectl apply -f yml/kafkapod.yml
kubectl apply -f ./yml/siege.yml
kubectl apply -f yml/configmap.yml
