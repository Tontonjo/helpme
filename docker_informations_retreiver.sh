#!/bin/bash

# Tonton Jo - 2021
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# This scripts aims to retreive usefull informations from my viewers in order to help them better.
# It's not intended to get private informations, but as this is scripted, some may be unintentionnaly get
# Please check your upload before sharing the link

version=1.5

# V1.0: Initial Release
# V1.1: enhencement, add docker networks
# V1.2: add docker info
# V1.3: add mountpoints
# V1.4: add root rights check :-)
# V1.5: remove container to get command, use built-in docker commands instead

# Sources:
# https://gist.github.com/jonlabelle/8cbd78c9277e76cb21a142f0c556e939

echo "----------------------------------------------------------------"
echo "Tonton Jo - 2022"
echo "docker_informations_retreiver V$version"
echo "----------------------------------------------------------------"

# -----------------ENVIRONNEMENT VARIABLES----------------------
URL="https://file.io"
DEFAULT_EXPIRE="14d" # Default to 14 days
FILE=docker_container_informations_uploader.txt
dt=$(date '+%d/%m/%Y %H:%M:%S');
hostname=$(hostname)
hostip=$(hostname -I)
loglastlines=100
# ---------------END OF ENVIRONNEMENT VARIABLES-----------------

# check if root
if [[ $(id -u) -ne 0 ]] ; then echo "- Please run as root / sudo" ; exit 1 ; fi

echo "- Creating log file"
# Quotes ensure format is kept
echo "-------------------------------- HOST INFOS --------------------------------" 		> docker_container_informations_uploader.txt
echo "Time of generation: $dt" 									>> docker_container_informations_uploader.txt
echo "hostname: $hostname" 									>> docker_container_informations_uploader.txt
echo "IP: $hostip" 										>> docker_container_informations_uploader.txt
echo "Host mounts: " 										>> docker_container_informations_uploader.txt
lsblk		 										>> docker_container_informations_uploader.txt
echo "-------------------------------- END OF HOST INFOS --------------------------------" 	>> docker_container_informations_uploader.txt
echo "- Getting general Docker informations"							
echo "-------------------------------- DOCKER INFO --------------------------------" 		>> docker_container_informations_uploader.txt
docker info																					>> docker_container_informations_uploader.txt
echo "-------------------------------- END OF INFO STATS --------------------------------"	>> docker_container_informations_uploader.txt
echo "- Getting general Docker stats"	
echo "-------------------------------- DOCKER STATS --------------------------------" 		>> docker_container_informations_uploader.txt
docker stats --all --no-stream									>> docker_container_informations_uploader.txt
echo "-------------------------------- END OF DOCKER STATS --------------------------------"	>> docker_container_informations_uploader.txt
echo "- Getting general Docker networks infos"	
echo "-------------------------------- DOCKER NETWORKS --------------------------------" 	>> docker_container_informations_uploader.txt
docker network ls										>> docker_container_informations_uploader.txt
echo "-------------------------------- END OF DOCKER NETWORKS --------------------------------"	>> docker_container_informations_uploader.txt

if [ $# -eq 0 ]; then
echo "- No container specified - getting infos about all containers"
	containerlist=$(docker stats --all --no-stream | awk '{print $2}' | tail -n +2)
else
	containerlist=$@
fi
echo "- Getting needed container to retreive informations - this may take some times"
docker inspect --help > /dev/null
if [ $? -eq 0 ]; then
	for I in $containerlist ; do
		echo "- Container $I - Getting Docker stats informations"
		# Get command used to start container
		docker inspect nextcloud > /dev/null
		if [ $? -eq 0 ]; then
			echo "-------------------------------- DOCKER $I INFOS --------------------------------" 		>> docker_container_informations_uploader.txt
			echo " Image: "													>> docker_container_informations_uploader.txt
			docker inspect --format='{{.Config.Image}}' $I					>> docker_container_informations_uploader.txt
			echo " State running? "											>> docker_container_informations_uploader.txt
			docker inspect --format='{{.State.Running}}' $I					>> docker_container_informations_uploader.txt
			echo " Restart Policy: "										>> docker_container_informations_uploader.txt
			docker inspect --format='{{.HostConfig.RestartPolicy.Name}}' $I	>> docker_container_informations_uploader.txt
			echo " Restart Policy: "										>> docker_container_informations_uploader.txt
			docker inspect --format='{{.Config.Env}}' $I					>> docker_container_informations_uploader.txt
			echo " Container IP: "											>> docker_container_informations_uploader.txt
			docker inspect --format='{{.NetworkSettings.IPAddress}}' $I		>> docker_container_informations_uploader.txt
			echo " Ports: "													>> docker_container_informations_uploader.txt
			docker inspect --format='{{.NetworkSettings.Ports}}' $I			>> docker_container_informations_uploader.txt
			echo " Bridge?: "												>> docker_container_informations_uploader.txt
			docker inspect --format='{{.NetworkSettings.Bridge}}' $I		>> docker_container_informations_uploader.txt
			echo " Volume Binds: "											>> docker_container_informations_uploader.txt
			docker inspect --format='{{.HostConfig.Binds}}' $I				>> docker_container_informations_uploader.txt

			echo "-------------------------------- DOCKER $I INFOS" --------------------------------" 		>> docker_container_informations_uploader.txt
			echo "-------------------------------- DOCKER $I LOG --------------------------------" 			>> docker_container_informations_uploader.txt
			docker logs -t $I | tail -$loglastlines									>> docker_container_informations_uploader.txt
			echo "-------------------------------- END DOCKER $I LOG --------------------------------" 		>> docker_container_informations_uploader.txt
			
		else
			echo "- Failed to run with specified container $I - does it exist?"
			echo "- Script will exit now"
			sleep 7
			exit
		fi
		done	
		# Checking and sharing output
		echo "- Validating file exist" 
		if [ ! -f "$FILE" ]; then
			echo "File ${FILE} not found"
			exit 1
		fi
		read -p "- Do you want to upload this log to file.io and download it? y = yes / anything = no: " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo "- Defining expidation to $DEFAULT_EXPIRE" 
			EXPIRE=${2:-$DEFAULT_EXPIRE}
			echo "- Uploading file to file.io"
			RESPONSE=$(curl -# -F "file=@${FILE}" "${URL}/?expires=${EXPIRE}")
				if [ $? -eq 0 ]; then
					echo "- Upload Successfull!"
					echo "- Please download your file then share it with us"
					echo "- Before share, check it doesnt contains any private informations"
					echo " -------------------------------- SHARE THIS --------------------------------"
					echo "${RESPONSE}" | tr , \\n | grep link
					echo " -------------------------------- SHARE THIS --------------------------------"
				else
					 echo "- Upload Failed - Something went wrong!"
				fi
			else
			echo "- Your log file is available locally at:"
			realpath $FILE
fi
	else
		echo "- Failed to download needed ressources using docker pull"
		echo "- Script will exit now"
		sleep 7
		exit
	fi
