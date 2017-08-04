#!/bin/sh
#

IMAGE_NAME='com.gft.zuul:latest'
echo 'Launching new container based on image' $IMAGE_NAME

docker run -e 'SPRING_PROFILES_ACTIVE=default,dev' -d -p 11002:11002 $IMAGE_NAME
echo 'Success'