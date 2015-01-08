# boxcar_notifier

These scripts are used to send <a href=http://boxcar.io>Boxcar</a> notifications. They allow for notifications to be sent to specific
user defined userids and groupids that are managed with a ```.user``` and ```.group``` file documented below.

<h2>Setup</h2>

Set the below variables within ```send_alert.sh.```

```
#This parameter specifies the directory containing the .user and .group file.
boxcar_config_dir="/Users/sfederman/.boxcar"

#send_alert specifies location of send_alert.sh
send_alert="/Users/sfederman/boxcar_notifier/send_alert_simple.sh"
```
<h3>Config files</h3>

<h4>.user file</h4>

```
#UserID:User Name:Device Name:ACCESS_TOKEN
1:username1:device_name:ACCESS_TOKEN
2:username2:device_name:ACCESS_TOKEN
```
Currently, the only relevant portion is the UserID and ACCESS_TOKEN in the .user file. The username and
devicename are ignored and used only for tracking purposes.
The userid can be any unique identifier, and must start at the beginning of the line.

<h4>.group file</h4>

```
#GroupID:Group Name:UserID (csv)
G1:groupname1:1, 2
```
Within the .group file, the groupname is currently ignored, and is only used for tracking purposes. The
groupid can be any unique identifier, and must start at the beginning of the line. The default .group file
uses G1, G2, etc... to distinguish from userids, but this is not strictly necessary. The UserID is a comma
separated list of UserIDs from the .user file.

<h2>Usage</h2>


Send Boxcar notification to userid 1.
```
send_alert.sh -u 1 -t "Title" -l "This is an <B>HTML</B> message sent to a user."
```
Send Boxcar notification to groupid G1.
```
send_alert.sh -g G1 -t "Title" -l "This is an <B>HTML</B> message sent to a group."
```

Send Boxcar alert without setting up users and groups.

```
send_alert_simple.sh -f ~/.boxcar/.boxcartoken -t "Title" -l "This is an <B>HTML</B> message."
```
