#!/bin/bash	
kubectl delete -f k8s/deployment.yaml
echo "Please allow at least a minutes for all pods to terminate before running deploy again"
echo 
kubectl get pods
echo 
echo "Checking again in 30s..."
sleep 30s
kubectl get pods
