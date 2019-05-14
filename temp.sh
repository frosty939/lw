#!/bin/bash

# checking permissions of the user
(read -r "username? " user ; find /home/$user -type f \( -perm -04000 -o -perm -02000 \) \-exec ls -lg {} \;) || echo whoops; exit 1

# view incoming pings
	tcpdump -nnqt -i any icmp

#
