#!/bin/sh
#

IMAGE_NAME='com.gft/zuul:0.0.1-SNAPSHOT'
echo 'Stopping containers based on' $IMAGE_NAME

echo 'Searching for previously running containers...'
CONTAINERS_RUNNING=`docker ps -a -q --filter ancestor=$IMAGE_NAME --format="{{.ID}}"`

if test -n "$CONTAINERS_RUNNING";
then

	echo 'Previously running containers based on the same image are:'
	echo $CONTAINERS_RUNNING

	echo 'Trying to stop previously running containers...'
	CONTAINERS_STOPPED=`docker stop $CONTAINERS_RUNNING`

	if test -n "$CONTAINERS_STOPPED";
	then
		echo "Successfully stopped containers"

		echo "Trying to remove previously running containers"
		CONTAINERS_REMOVED=`docker rm $CONTAINERS_STOPPED`

		if test -n "$CONTAINERS_STOPPED";
		then
			echo "Successfully removed containers"
		else
			echo "ERROR: Couldn't remove previously running containers!"
		fi

	else
		echo "ERROR: Couldn't stop previously running containers!"
	fi

else
	echo 'No previously running containers were found'
fi
