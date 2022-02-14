#!/bin/bash

docker login -u $1 -p $2
if [ "$3" == "react" ]
then
docker pull rolliku/frontend:latest
docker run -d --name front -p 80:80 rolliku/frontend:latest
elif [ "$3" == "java" ]
then
docker pull rolliku/backend:latest
docker run -d --name back -p 8080:8080 rolliku/backend:latest
fi