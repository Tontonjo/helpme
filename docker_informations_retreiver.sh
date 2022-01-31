#!/bin/sh

# Tonton Jo - 2021
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# This scripts aims to retreive usefull informations from my viewers in order to help them better.
# It's not intended to get private informations, but as this is scripted, some may be unintentionnaly get
# Please check your upload before sharing the link

# Usage:
# Execute script and to be complete, specify the container names you want to retreive informations from
# bash docker_informations_retreiver.sh container1 container2
# The script then generate a txt file with informations about running containers that you can uplod to file.io or share yourself.

version=1.0
# V1.0: Initial Release

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
# ---------------END OF ENVIRONNEMENT VARIABLES-----------------



echo "- Creating log file"
# Quotes ensure format is kept
echo "--------------------------------  INFOS --------------------------------" 				> docker_container_informations_uploader.txt
echo "Time of generation: $dt" 																	>> docker_container_informations_uploader.txt
echo "-------------------------------- END OF INFOS --------------------------------" 			>> docker_container_informations_uploader.txt
echo "- Getting Docker stats informations"
echo "- docker stats --all --no-stream"
dockerstatus=$(docker stats --all --no-stream)
echo "-------------------------------- DOCKER STATS --------------------------------" 			>> docker_container_informations_uploader.txt
echo "$dockerstatus" 																			>> docker_container_informations_uploader.txt
echo "-------------------------------- END OF DOCKER STATS --------------------------------"	>> docker_container_informations_uploader.txt

if [ $# -eq 0 ]; then
	echo "- No container specified - continuing"
else	
	echo "- Getting needed container to retreive informations - this may take some times"
	docker pull nexdrew/rekcod
	if [ $? -eq 0 ]; then
		for I in "$@" ; do
		echo "- Container $I specified - Getting Docker stats informations"
		command=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nexdrew/rekcod $I)
		echo "-------------------------------- DOCKER $I COMMAND --------------------------------" 		>> docker_container_informations_uploader.txt
		echo "$command"																					>> docker_container_informations_uploader.txt
		echo "-------------------------------- DOCKER $I COMMAND --------------------------------" 		>> docker_container_informations_uploader.txt
		done
	else
		echo "- Container run failed to retreive informations, please control your parameters"
		exit
	fi
fi


echo "- Validating file exist" 
if [ ! -f "$FILE" ]; then
    echo "File ${FILE} not found"
    exit 1
fi
read -p "- Do you want to upload this log to file.io and download it? y = yes / anything = no: " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "- Defining expidation to $DEFAULT_EXPIRE" 
	EXPIRE=${2:-$DEFAULT_EXPIRE}
	echo "- File uploaded"
	RESPONSE=$(curl -# -F "file=@${FILE}" "${URL}/?expires=${EXPIRE}")
		if [ $? -eq 0 ]; then
		    echo "- Upload Successfull!"
			echo "- Please download your file then share it with us"
			echo "- Before share, check it doesnt contains any private informations"
			echo " -------------------------------- SHARE THIS --------------------------------"
			echo "${RESPONSE}" | tr , \\n | grep link
			echo " -------------------------------- SHARE THIS --------------------------------"
			echo " - File can only be downloaded once"
		else
			 echo "- Upload Failed - Something went wrong.!"
		fi
	else
	echo "- Your log file is available locally at:"
	realpath $FILE
fi
