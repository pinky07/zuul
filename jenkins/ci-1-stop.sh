#!/bin/sh
#

#
# Function/Procedures
#

cleanUpDocker() {
	echo 'Looking for dangling images...' 
	DANGLING_IMAGES=`docker images -f dangling=true -q`
	
	if test -n "$DANGLING_IMAGES";
	then

		echo 'Attempting to remove dangling images...'
		DANGLING_IMAGES_REMOVED=`docker rmi ${DANGLING_IMAGES}`

		if test -n "$DANGLING_IMAGES_REMOVED";
		then 
			echo 'Successful'
		else 
			echo "ERROR: Couldn't remove dangling images!"
		fi
	else
		echo 'No dangling images were found'
	fi

	echo 'Looking for dangling volumes...'
	DANGLING_VOLUMES=`docker volume ls -f dangling=true -q`

	if test -n "$DANGLING_VOLUMES";
	then

		echo 'Attempting to remove dangling volumes...'
		DANGLING_VOLUMES_REMOVED=`docker volume rm $DANGLING_VOLUMES`

		if test  -n "$DANGLING_VOLUMES_REMOVED";
		then 
			echo 'Successful'
		else 
			echo "ERROR: Couldn't remove dangling volumes!"
		fi

	else 
		echo 'No dangling volumes were found'
	fi
}

removeContainer() {
	NAME=$1
	VERSION=$2
	NAME_VERSION="$NAME:$VERSION"

	echo 'Looking for containers running based on' ${NAME_VERSION} '...'
	CONTAINERS_RUNNING=`docker ps -a | grep "$NAME_VERSION" | awk '{print $1}'`

	if test -n "$CONTAINERS_RUNNING";
	then

		echo 'Stopping the containers found...'
		CONTAINERS_STOPPED=`echo ${CONTAINERS_RUNNING} | xargs docker stop`

		if test -n "$CONTAINERS_STOPPED";
		then

			echo "Removing the stopped containers..."
			CONTAINERS_REMOVED=`echo ${CONTAINERS_STOPPED} | xargs docker rm -v`

			if test -n "$CONTAINERS_STOPPED";
			then
				echo "Successful"
			else
				echo "ERROR: Couldn't remove running containers!"
			fi
		else
			echo "ERROR: Couldn't stop running containers!"
		fi
	else
		echo 'No containers were found'
	fi
}

removeImage() {
	NAME=$1
	VERSION=$2
	NAME_VERSION="$NAME:$VERSION"

	echo 'Looking for an image named' ${NAME_VERSION} '...'
	IMAGE=`docker images | grep -E "$NAME\s+$VERSION" | awk '{print $3}'`

	if test -n "$IMAGE";
	then

		echo 'Removing the image found...'
		IMAGE_REMOVED=`echo ${IMAGE} | xargs docker rmi`

		if test -n "$IMAGE_REMOVED";
		then 
			echo "Successful"
		else 
			echo "ERROR: Couldn't remove the image found"
		fi
	else 
		echo "No image was found"
	fi
}

#
# Actual script
#

echo 'Cleaning up Docker...'
cleanUpDocker

# Stop application
echo 'Removing previous app image and containers...'
removeContainer 'com.gft.zuul' 'latest' 
removeImage 'com.gft.zuul' 'latest' 

#
# References:
#   - https://www.shellscript.sh/functions.html
#   - https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes