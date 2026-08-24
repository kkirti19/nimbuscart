#!/bin/bash
set -e
IMAGE=nimbuscart-q61
docker build -t "$IMAGE" .
docker run -d --name nimbuscart-q61 -p 8080:80 "$IMAGE"
docker ps
docker images "$IMAGE"
docker tag "$IMAGE" YOUR_DOCKERHUB_USERNAME/$IMAGE:latest
docker login
docker push YOUR_DOCKERHUB_USERNAME/$IMAGE:latest
