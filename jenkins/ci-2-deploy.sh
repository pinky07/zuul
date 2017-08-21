#!/bin/sh
#

IMAGE_NAME='com.gft.zuul:latest'
echo 'Launching new container based on image' $IMAGE_NAME '...'

docker run -e 'SPRING_PROFILES_ACTIVE=default,dev' -d -p 11002:11002 $IMAGE_NAME

echo 'Waiting 20s for APP container to start...'
sleep 20s

echo 'APP Logs'
docker ps -a | grep "$IMAGE_NAME" | awk '{print $1}' | xargs docker logs

echo 'Success'
