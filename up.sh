#!/bin/bash

## Composer project name instead of git main folder name
export COMPOSE_PROJECT_NAME=mongodb-sharding-docker-compose

## Generate global auth key between cluster nodes
openssl rand -base64 756 > mongodb.key
chmod 600 mongodb.key
chmod 999:999 mongodb.key
## Start the whole stack
docker-compose up -d
sleep 5
## Config servers setup
docker exec -it mongodb-sharding-docker-compose_mongo-configserver-01_1 sh -c "mongo --port 27017 < /mongo-configserver.init.js"

## Shard servers setup
docker exec -it mongodb-sharding-docker-compose_mongo-shard-01a_1 sh -c "mongo --port 27018 < /mongo-shard-01.init.js" 
docker exec -it mongodb-sharding-docker-compose_mongo-shard-02a_1 sh -c "mongo --port 27019 < /mongo-shard-02.init.js"
docker exec -it mongodb-sharding-docker-compose_mongo-shard-03a_1 sh -c "mongo --port 27020 < /mongo-shard-03.init.js"

## Apply sharding configuration
sleep 15
docker exec -it mongodb-sharding-docker-compose_mongo-router-01_1 sh -c "mongo --port 27017 < /mongo-sharding.init.js"

## Enable admin account
docker exec -it mongodb-sharding-docker-compose_mongo-router-01_1 sh -c "mongo --port 27017 < /mongo-auth.init.js"