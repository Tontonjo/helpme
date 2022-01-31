#!/bin/sh

# Tonton Jo - 2021
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# This scripts aims to retreive usefull informations from my viewers in order to help them better.
# It's not intended to get private informations, but as this is scripted, some may be unintentionnaly get
# Please check your upload before sharing the link

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
execdir=$(dirname $0)
# ---------------END OF ENVIRONNEMENT VARIABLES-----------------

echo "- Getting Docker stats informations"
echo "- docker stats --all --no-stream"
dockerstatus=$(docker stats --all --no-stream)
if [ $# -eq 0 ]; then
	echo "- No container specified - continuing"
else	
	echo "- Container $1 specified - Getting Docker stats informations"
	echo "- Getting needed container to retreive informations - this may take some times"
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nexdrew/rekcod $1
	if [ $? -eq 0 ]; then
	command=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nexdrew/rekcod $1)
else
	 echo "- Container run failed to retreive informations, please control your parameters"
	 exit
	 
fi
fi


echo "- Creating log file"
# Quotes ensure format is kept
echo "
--------------------------------  INFOS --------------------------------
Time of generation: $dt
-------------------------------- END OF INFOS --------------------------------
-------------------------------- DOCKER $1 COMMAND --------------------------------
"$command"
-------------------------------- DOCKER $1 COMMAND --------------------------------
-------------------------------- DOCKER STATS --------------------------------
"$dockerstatus"
-------------------------------- END OF DOCKER STATS --------------------------------
-------------------------------- DOCKER $1 COMMAND --------------------------------
"$command"
-------------------------------- DOCKER $1 COMMAND --------------------------------
" > docker_container_informations_uploader.txt

echo "- Defining expidation to $DEFAULT_EXPIRE" 
EXPIRE=${2:-$DEFAULT_EXPIRE}

echo "- Validating file exist before upload" 
if [ ! -f "$FILE" ]; then
    echo "File ${FILE} not found"
    exit 1
fi
read -p "- Do you want to upload this log to file.io and download it? y = yes / anything = no: " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "- File uploaded"
	RESPONSE=$(curl -# -F "file=@${FILE}" "${URL}/?expires=${EXPIRE}")
		if [ $? -eq 0 ]; then
		    	echo "- Upload Successfull!"
			echo "- Please download your file then share it with us"
			echo "- Before share, check it doesnt contains any private informations"
			echo " -------------------------------- SHARE THIS --------------------------------"
			echo "${RESPONSE}" | tr , \\n | grep link
			echo " -------------------------------- SHARE THIS --------------------------------"
		else
			 echo "- Upload Failed - Something went wrong.!"
	else
	echo "
	- Your log file is available locally at:
	- $execdir/$FILE"
	fi
fi
