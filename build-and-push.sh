#!/bin/bash

export DOCKER_USERNAME=gamecat69
export DOCKER_REPO=ion

# Copy in Dockerfile
cp ./ion-ltp/Dockerfile ./Dockerfile

# Build the image
docker build -t ${DOCKER_REPO}:latest .

# Tag with docker.io repo info
docker tag ${DOCKER_REPO}:latest ${DOCKER_USERNAME}/${DOCKER_REPO}:latest

# Login to docker hub
docker login --username=${DOCKER_USERNAME}

# Push to docker hub
docker push ${DOCKER_USERNAME}/${DOCKER_REPO}:latest
