#!/bin/bash

# Boxcar notifier script
# adopted from: 
#	http://help.boxcar.io/knowledgebase/articles/306788-how-to-send-a-notification-to-boxcar-users
# Scot Federman

boxcar_config_dir="/Users/sfederman/.boxcar"
send_alert="/Users/sfederman/boxcar_notifier/send_alert.sh"


bold=$(tput bold)
normal=$(tput sgr0)
host=$(hostname)
scriptname=${0##*/}

optspec=":ha:f:t:l:s:n:i:o:u:g:"
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
		u) userid=${OPTARG};;
		g) groupid=${OPTARG};;

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

userid_to_token() {
	userid=$1
	echo $(grep ^$userid $boxcar_config_dir/.user | awk -F: '{print $4}')
}

groupid_to_userid() {
	groupid=$1
	echo $(grep ^$groupid $boxcar_config_dir/.group | awk -F: '{print $3}')
}

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

if [[ ! $source_name ]]
then
	source_name=$host
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
elif [[ $ACCESS_TOKEN ]]
then
	:
elif [[ $userid ]]
then
	ACCESS_TOKEN=$(userid_to_token $userid)
	if [[ ! $ACCESS_TOKEN ]]
	then
		echo "UserID $userid not found."
		exit
	fi
	$send_alert -a "$ACCESS_TOKEN" -t "$title" -l "$long_message" -s "$sound" -n "$source_name" -i "icon_url" -o "$open_url"
	echo $ACCESS_TOKEN
elif [[ $groupid ]]
then
	ACCESS_TOKEN_LIST=$(groupid_to_userid $groupid)
	echo $ACCESS_TOKEN_LIST
	IFS=","

	for i in $ACCESS_TOKEN_LIST
	do
		user=$(echo "$i" | tr -d ' ')
		ACCESS_TOKEN=$(userid_to_token $user)
		echo -e "$user\t$ACCESS_TOKEN"
		$send_alert -a "$ACCESS_TOKEN" -t "$title" -l "$long_message" -s "$sound" -n "$source_name" -i "icon_url" -o "$open_url"
	done
fi
