#!/bin/bash
set -e
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo docker pull nginx:latest
sudo docker run -d --name q62-nginx -p 80:80 nginx:latest
sudo docker ps
