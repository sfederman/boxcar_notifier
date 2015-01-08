# boxcar_notifier

These scripts are used to send Boxcar notifications using a userid and groupid that can be managed with a .user and .group file.

.user file

```
#UserID:User Name:Device Name:ACCESS_TOKEN
1:username1:device_name:ACCESS_TOKEN
2:username2:device_name:ACCESS_TOKEN
```
Currently, the only relevant portion is the UserID and ACCESS_TOKEN in the .user file. The username and devicename are 
currently ignored and used only for tracking purposes.
The userid can be any unique identifier, and must start at the beginning of the line.

.group file
```
#GroupID:Group Name:UserID (csv)
G1:groupname1:1, 2
```
Within the .group file, the groupname is currently ignored, and is only used for tracking purposes. The groupid can be any 
unique identifier, and must start at the beginning of the line. I'm using G# to distinguish from userids, but this is not 
strictly necessary. The UserID is a comma separated list of UserIDs from the .user file.
