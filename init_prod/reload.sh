#!/bin/bash
if [ "$1" == "react" ]
then
docker pull rolliku/frontend:latest
docker stop front
docker rm front
docker run -d --name front -p 80:80 rolliku/frontend:latest
elif [ "$1" == "java" ]
then
docker pull rolliku/backend:latest
docker stop back
docker rm back
docker run -d --name back -p 8080:8080 rolliku/backend:latest
fi

docker system prune -f