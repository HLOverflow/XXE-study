#!/bin/bash
docker-compose up --build -d
echo 
echo "Visit http://localhost:8082/xxe to access the vulnerable web application"
echo "Use the following to access the attacker file hosting server: docker container exec -it attackerserver-php bash"
echo "Use http://attackerserver-php:8888 to access the attacker hosting server from the vulnerable web app."
