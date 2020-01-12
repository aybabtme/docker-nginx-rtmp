#!/bin/bash

set -eu

image_name="nginx-rtmp"
nginx_rtmp_version="v1.2.1"

HUB_USER=$(op get item Docker | jq -r '.details.fields[] | select(.designation=="username").value')
HUB_PWD=$(op get item Docker | jq -r '.details.fields[] | select(.designation=="password").value')

echo "Logging into Docker Hub"
echo $HUB_PWD | docker login -u $HUB_USER --password-stdin

echo "Building $sqlboiler_version image"
docker build --build-arg NGINX_RTMP_VERSION=$nginx_rtmp_version -t aybabtme/$image_name:$nginx_rtmp_version .
docker tag aybabtme/$image_name:$nginx_rtmp_version aybabtme/$image_name:latest

echo "Pushing image to Docker Hub"
docker push aybabtme/$image_name:$nginx_rtmp_version
docker push aybabtme/$image_name:latest
docker rmi aybabtme/$image_name:$nginx_rtmp_version
docker rmi aybabtme/$image_name:latest