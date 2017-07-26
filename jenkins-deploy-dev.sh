#!/bin/sh
#

IMAGE_NAME='com.gft/zuul:0.0.1-SNAPSHOT'
echo 'Launching new container based on image' $IMAGE_NAME

docker run -e 'SPRING_PROFILES_ACTIVE=default,dev' -d -p 11000:11000 $IMAGE_NAME
echo 'Success'