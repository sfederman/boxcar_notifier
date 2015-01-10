#!/bin/bash

# Boxcar notifier script
# adopted from:
# http://help.boxcar.io/knowledgebase/articles/306788-how-to-send-a-notification-to-boxcar-users
# Scot Federman

#This parameter specifies the directory containing the .user and .group file.
boxcar_config_dir="/Users/sfederman/.boxcar"

#send_alert specifies location of send_alert.sh
send_alert="/Users/sfederman/boxcar_notifier/send_alert_simple.sh"

# If .config file exists, use it to override defaults
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [[ -e $DIR/.config ]]
then
	source "$DIR/.config"
fi
bold=$(tput bold)
normal=$(tput sgr0)
host=$(hostname)
scriptname=${0##*/}

optspec=":ht:l:s:n:i:o:u:g:d"
while getopts "$optspec" option; do
	case "${option}" in
		h) HELP=1;;
		u) userid=${OPTARG};;
		g) groupid=${OPTARG};;
		t) title=${OPTARG};;
		l) long_message=${OPTARG};;
		s) sound=${OPTARG};;
		n) source_name=${OPTARG};;
		i) icon_url=${OPTARG};;
		o) open_url=${OPTARG};;
		d) DRY_RUN=1;;

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

	-d	Dry run. Show users that would be alerted, but do not send alert.

	-u	Specify userid to alert

		Specifies a userid (from .user file) to send alert

	-g	Specify groupid to alert

		Specifies a groupid (from .group file) to send alert

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

	Send Boxcar notification to a userid 1.
		$scriptname -u 1 -t "Title" -l "This is an <B>HTML</B> message."

	Send Boxcar notification to a groupid G1.
		$scriptname -g G1 -t "Title" -l "This is an <B>HTML</B> message."

USAGE
	exit
fi

userid_to_token() {
	userid=$1
	grep "^$userid:" "$boxcar_config_dir/.user" | awk -F: '{print $4}'
}

groupid_to_userid() {
	groupid=$1
	grep "^$groupid:" "$boxcar_config_dir/.group" | awk -F: '{print $3}'
}

userid_to_name_device() {
	userid=$1
	grep "^$userid:" "$boxcar_config_dir/.user" | awk -F: '{print $2":"$3}'
}

user_alert() {
	userid=$1
	ACCESS_TOKEN=$(userid_to_token "$userid")
	if [[ ! $ACCESS_TOKEN ]]
	then
		echo "UserID $userid not found."
		return
	fi
	if [[ $DRY_RUN ]]
	then
		name_device=$(userid_to_name_device "$userid")
		echo "$userid:$name_device:$ACCESS_TOKEN"
	else
		$send_alert -a "$ACCESS_TOKEN" -t "$title" -l "$long_message" -s "$sound" -n "$source_name" -i "$icon_url" -o "$open_url"
	fi
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
		ACCESS_TOKEN=$(cat "$ACCESS_TOKEN_FILE")
	else
		echo "$ACCESS_TOKEN_FILE is not a readable file."
		exit
	fi
elif [[ $ACCESS_TOKEN ]]
then
	:
elif [[ $userid ]]
then
	user_alert "$userid"
elif [[ $groupid ]]
then
	ACCESS_TOKEN_LIST=$(groupid_to_userid "$groupid")
	if [[ ! $ACCESS_TOKEN_LIST ]]
	then
		echo "GroupID $groupid not found."
		exit
	else

		IFS=","

		for i in $ACCESS_TOKEN_LIST
		do
			user=$(echo "$i" | tr -d ' ')
			user_alert "$user"
		done
	fi
fi
