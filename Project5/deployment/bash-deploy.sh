#!/bin/bash

IMAGE_NAME="edgyduck/burke-ceg3120:latest"
CONTAINER_NAME="burke-ceg3120-P5"

echo "Stopping running container"
docker stop $CONTAINER_NAME 2>/dev/null

echo "Removing old container"
docker rm $CONTAINER_NAME 2>/dev/null

echo "Pulling latest image release from DockerHub"
docker pull $IMAGE_NAME

echo "Starting new container"
docker run -d --name $CONTAINER_NAME -p 4200:4200 $IMAGE_NAME

echo "Deployment complete"
