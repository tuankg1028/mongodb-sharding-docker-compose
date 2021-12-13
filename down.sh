#!/bin/bash

export COMPOSE_PROJECT_NAME=mongodb-sharding-docker-compose
docker-compose down
rm -f ./mongodb.key
