#!/bin/bash
kubectl delete svc,deploy,pod -n storagerent --all
kubectl delete ns storagerent
kubectl create ns storagerent
kubectl apply -f yml/kafkapod.yml
kubectl apply -f ./yml/siege.yml
kubectl apply -f yml/configmap.yml
