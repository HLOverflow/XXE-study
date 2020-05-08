#!/bin/bash
docker-compose up --build -d
echo 
echo "Visit http://localhost:8081 to access the vulnerable web application"
echo "Use the following to access the attacker file hosting server: docker container exec -it attackerserver bash"
