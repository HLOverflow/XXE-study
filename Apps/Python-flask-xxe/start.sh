#!/bin/bash
docker-compose up --build -d
echo 
echo "Visit http://localhost:8081 to access the vulnerable web application"
echo "Use the following to access the attacker file hosting server: docker container exec -it attackerserver-flaskxxe bash"
echo "Use http://attackerserver-flaskxxe:8888 to access the attacker hosting server from the vulnerable web app."
