# Boxcar notifier

These scripts are used to send <a href=http://boxcar.io>Boxcar</a> notifications. They allow for notifications to be sent to specific
user defined userids and groupids that are managed with a ```.user``` and a ```.group``` file documented below.

<h2>Installation</h2>

```git clone https://github.com/sfederman/boxcar_notifier.git```

Set the below variables within ```send_alert.sh```.

```
#This parameter specifies the directory containing the .user and .group file.
boxcar_config_dir="/Users/sfederman/.boxcar"

#send_alert specifies location of send_alert.sh
send_alert="/Users/sfederman/boxcar_notifier/send_alert_simple.sh"
```
<h3>Config files</h3>

<h4>.user file</h4>

```
#UserID:UserName:Device Name:ACCESS_TOKEN
1:Frederica Doe:iPhone:ACCESS_TOKEN
2:Frederica Doe:iPad:ACCESS_TOKEN
3:Charlie Smith:iPhone:ACCESS_TOKEN
4:Keyser Soze:iPhone:ACCESS_TOKEN
```

Field | Use|
----- | ---
UserID|Unique Identifier
UserName|Unused by scripts, useful for tracking
DeviceName|Unused by scripts, useful for tracking
ACCESS_TOKEN|Boxcar access token

Currently, the only relevant portion is the UserID and ACCESS_TOKEN in the .user file. The username and
devicename are ignored and used only for tracking purposes.
The userid can be any unique identifier, and must start at the beginning of the line.

<h4>.group file</h4>

```
#GroupID:Group Name:UserID (csv)
G1:Frederica:1,2
G2:Everyone:1,2,3,4
```

Field | Use|
----- | ---
GroupID|Unique Identifier
GroupName|Unused by scripts, useful for tracking
UserID|Comma Separated List of UserIDs from .user file

Within the .group file, the groupname is currently ignored, and is only used for tracking purposes. The
groupid can be any unique identifier, and must start at the beginning of the line. The default .group file
uses G1, G2, etc... to distinguish from userids, but this is not strictly necessary. The UserID is a comma
separated list of UserIDs from the .user file.

<h2>Usage</h2>


Send Boxcar notification to userid 1.
```
send_alert.sh -u 1 -t 'Title' -l 'This is an <B>HTML</B> message sent to a user.''
```
Send Boxcar notification to groupid G1.
```
send_alert.sh -g G1 -t 'Title' -l 'This is an <B>HTML</B> message sent to a group.
```

Send Boxcar alert without setting up users and groups.

```
send_alert_simple.sh -f ~/.boxcar/.boxcartoken -t 'Title' -l 'This is an <B>HTML</B> message.''
```
