#!/bin/bash

cd /home/ubuntu/realworld-backend-spring-ddd/
chmod +x mvnw
make
cp /home/ubuntu/realworld-backend-spring-ddd/target/backend-0.0.1-SNAPSHOT.jar /home/ubuntu/git/JavaApp/app.jar
cd /home/ubuntu/git/JavaApp/
docker build -t rolliku/backend .
cd /home/ubuntu/Client
npm i
npm run build
cp -R /home/ubuntu/Client/build /home/ubuntu/git/React/
cd /home/ubuntu/git/React
sudo docker build -t rolliku/frontend .
sudo docker login -u $1 -p $2
sudo docker push rolliku/frontend:latest
sudo docker push rolliku/backend:latest
