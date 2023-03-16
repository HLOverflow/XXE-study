#!/bin/bash	
echo -e '[*] Step 0 - Check for Minikube first'
which minikube
err=$?
if [ $err -eq 1 ]; then
    echo 'Please install minikube and set it up first';
    exit 1;
fi

minikube status | grep stopped
err=$?
if [ $err -eq 0 ]; then
    echo 'Please start minikube first...';
    exit 1;
fi

echo -e '[*] Step 1 - Link to Minikube VM docker'
eval $(minikube docker-env)
echo -e '[*] Step 2 - Build local images first'
./build.sh
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
echo -e '+---------------------------------+-----------------------------------------------------------------------------+'
echo -e '| attacker server (file hosting ) | kubectl exec -it '$(kubectl get pods -lapp=attackerserver -o name)' -- bash	|'
echo -e '+---------------------------------+-----------------------------------------------------------------------------+'
echo -e '| aws metadata simulator          | kubectl exec -it '$(kubectl get pods -lapp=metadata-simulator -o name)' -- bash	|'
echo -e '+---------------------------------+-----------------------------------------------------------------------------+'
echo -e '| vulnerable server               | kubectl exec -it '$(kubectl get pods -lapp=vulnerableserver -o name | head -n 1)' -- bash	|'
echo -e '+---------------------------------+-----------------------------------------------------------------------------+'

