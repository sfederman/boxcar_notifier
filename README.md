# Boxcar notifier

These scripts are used to send <a href=http://boxcar.io>Boxcar</a> notifications from the command line. They allow for notifications to be sent to specific
users and groups that are managed with a ```.user``` and a ```.group``` file documented below. The scripts should run on any
Linux/OSX machine. The only dependency is curl.


##Installation##

```git clone https://github.com/sfederman/boxcar_notifier.git```

Set the below variables within ```send_alert.sh```.

```
#This parameter specifies the directory containing the .user and .group file.
boxcar_config_dir="/Users/sfederman/.boxcar"

#send_alert specifies location of send_alert.sh
send_alert="/Users/sfederman/boxcar_notifier/send_alert_simple.sh"
```
###Config files###

####.user file####

```
#UserID:UserName:Device Name:ACCESS_TOKEN
1:Frederica Doe:iPhone:ACCESS_TOKEN
2:Frederica Doe:iPad:ACCESS_TOKEN
3:Charlie Smith:iPhone:ACCESS_TOKEN
4:Keyser Soze:iPhone:ACCESS_TOKEN
```

Field | Use|
----- | ---
```UserID```|Unique Identifier
```UserName```|Unused by scripts, useful for tracking
```DeviceName```|Unused by scripts, useful for tracking
```ACCESS_TOKEN```|Boxcar access token

Currently, the only fields used are the ```UserID``` and ```ACCESS_TOKEN```. The ```UserName``` and
```DeviceName``` fields are ignored and used only for tracking purposes.
The ```UserID``` can be any unique identifier, and must start at the beginning of the line.

####.group file####

```
#GroupID:GroupName:UserID_list (csv)
G1:Frederica:1,2
G2:Everyone:1,2,3,4
```

Field | Use|
----- | ---
```GroupID```|Unique Identifier
```GroupName```|Unused by scripts, useful for tracking
```UserIDList```|Comma Separated List of UserIDs from .user file

Currently, the only fields used are the ```GroupID``` and ```UserIDList```. The ```GroupName``` field is
ignored and used only for tracking purposes. The ```GroupID``` can be any unique identifier, and must
start at the beginning of the line. The default .group file uses G1, G2, etc... to distinguish ```GroupName```
from ```UserID```, but this is not strictly necessary. The ```UserIDList``` is a comma
separated list of ```UserID``` from the .user file.

##Usage##


Send Boxcar notification to UserID 1.
```
send_alert.sh -u 1 -t 'Title' -l 'This is an <B>HTML</B> message sent to a user.''
```
Send Boxcar notification to GroupID G1.
```
send_alert.sh -g G1 -t 'Title' -l 'This is an <B>HTML</B> message sent to a group.
```

Send Boxcar alert without setting up ```.user``` and ```.group``` files.

```
send_alert_simple.sh -f ~/.boxcar/.boxcartoken -t 'Title' -l 'This is an <B>HTML</B> message.''
```
