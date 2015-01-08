#!/bin/bash

# Boxcar notifier script
# Scot Federman

bold=$(tput bold)
normal=$(tput sgr0)
host=$(hostname)
scriptname=${0##*/}

optspec=":ha:f:t:l:s:n:i:o:"
while getopts "$optspec" option; do
	case "${option}" in
		h) HELP=1;;
		a) ACCESS_TOKEN=${OPTARG};;
		f) ACCESS_TOKEN_FILE=${OPTARG};;
		t) title=${OPTARG};;
		l) long_message=${OPTARG};;
		s) sound=${OPTARG};;
		n) source_name=${OPTARG};;
		i) icon_url=${OPTARG};;
		o) open_url=${OPTARG};;

		:)	echo "Option -$OPTARG requires an argument." >&2
			exit 1
			;;
	esac
done

if [[ $HELP -eq 1  ||  $# -lt 1 ]]
then
	cat <<USAGE

${bold}$scriptname${normal}

This program will send a Boxcar notification to any user/device. See 
http://help.boxcar.io/knowledgebase/articles/306788-how-to-send-a-notification-to-boxcar-users 
for further details.

${bold}Command Line Switches:${normal}

	-h	Show this help & ignore all other switches

	-a	Specify access token
	
		This is where you pass your access token. Your access token can be found 
		in Boxcar global setting pane. It is a string composed of letters and numbers. 
		Do not confuse it with your Boxcar email address.

	-f	Specify access token file
	
		This is where you pass the file containing the access token.

	-t	Specify title

		This parameter will contain the content of the alert and the title of the 
		notification in Boxcar. Max size is 255 chars.
		
	-l	Specify long message

		This is where you place the content of the notification itself. It can be 
		either text or HTML. Max size is 4kb.

	-s	Specify sound (optional)

		This is where you define the sound you want to play on your device. As a 
		default, the general sound is used. General sound typically defaults to 
		silent, but if you changed it, you can force the notification to be silent 
		with the "no-sound" sound name.	

	-n	Specify source name (optional)

		This is a short source name to show in inbox. Default is "Custom notification".
	
	-i	Specify icon url (optional)

		This is where you define the icon you want to be displayed within the 
		application inbox.
			
	-o	Specify open url (optional)

		If defined, Boxcar will redirect you to this url when you open the notification 
		from the Notification Center. It can be a http link like  
		http://maps.google.com/maps?q=cupertino or an inapp link 
		like twitter:///user?screen_name=vutheara﻿﻿

${bold}Usage:${normal}

	Send Boxcar notification.
		$scriptname -f ~/.boxcar/.boxcartoken -t "Title" -l "This is an <B>HTML</B> message."

USAGE
	exit
fi

if [[ $ACCESS_TOKEN_FILE ]]
then
	if [[ -r $ACCESS_TOKEN_FILE ]]
	then
		ACCESS_TOKEN=$(cat $ACCESS_TOKEN_FILE)
	else
		echo "$ACCESS_TOKEN_FILE is not a readable file."
		exit
	fi
elif [[ ! $ACCESS_TOKEN ]]
then
	echo "You must submit either an Access token (-a) or an Access token file (-f)."
	exit
fi

if [[ ! $title ]]
then
	echo "You must submit a title (-t)."
	exit
fi

if [[ ! $long_message ]]
then
	echo "You must submit a long_message (-l)."
	exit
fi

curl -d "user_credentials=$ACCESS_TOKEN" \
	-d "notification[title]=$title" \
	-d "notification[long_message]=$long_message" \
	-d "notification[sound]=$sound" \
	-d "notification[source_name]=$source_name" \
	-d "notification[icon_url]=$icon_url" ﻿\
	-d "notification[open_url]=$open_url" ﻿\
	https://new.boxcar.io/api/notifications

