#!/bin/bash	
echo -e '[*] Step 0 - Check for Minikube first'
which minikube
err=$?
if [ $err -eq 1 ]; then
    echo 'Please install minikube and set it up first';
    exit 1;
fi

minikube status | grep Running
err=$?
if [ $err -eq 1 ]; then
    echo 'Please start minikube first...';
    exit 1;
fi

echo -e '[*] Step 1 - Link to Minikube VM docker'
eval $(minikube docker-env)
echo -e '[*] Step 2 - Build local images first'
docker-compose build

echo -e '[*] Step 3 - Proceed to deploy built local images to Kubernetes in Minikube'
kubectl apply -f k8s/deployment.yaml
echo -e '[*] Please allow some time for deployment to minikube...'
sleep 20s
echo -e ''
echo -e 'EXPLOITATION'
echo -e ''
echo -e 'Visit \e[32mhttp://'$(minikube ip)':30000 \e[0mto access the vulnerable web application'
echo -e 'Use http://attackerserver-flaskxxe:8888 to access the attacker hosting server from the vulnerable web app.'
echo -e ''
echo -e 'DEBUGGING'
echo -e ''
echo -e 'Here are the kubernetest PODS:'
echo -e ''
kubectl get pods
echo -e ''
echo -e 'Access the relevant pods via their names...'
echo -e '$ kubectl exec -it <podname> -- bash'
echo -e ''
attkname=$(kubectl get pods -lapp=attackerserver --field-selector=status.phase==Running -o name)
simname=$(kubectl get pods -lapp=metadata-simulator --field-selector=status.phase==Running -o name)
vulname=$(kubectl get pods -lapp=vulnerableserver --field-selector=status.phase==Running -o name | head -n 1)
echo -e '+---------------------------------+-----------------------------------------------------------------------------+'
echo -e '| attacker server (file hosting ) | kubectl exec -it '$attkname' -- bash	|'
echo -e '+---------------------------------+-----------------------------------------------------------------------------+'
echo -e '| aws metadata simulator          | kubectl exec -it '$simname' -- bash	|'
echo -e '+---------------------------------+-----------------------------------------------------------------------------+'
echo -e '| vulnerable server               | kubectl exec -it '$vulname' -- bash	|'
echo -e '+---------------------------------+-----------------------------------------------------------------------------+'

