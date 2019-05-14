#!/bin/bash

echo -e "Information needed:\nKicked\nTime Logged in\nSSH Commands\nBreach of data?\nServices come back online\nTime Logged Out\n\n\nDO NOT Remove any logs only compress/move them.\n\n"

echo -n "Kicked (yes/no?): "
read kicked

echo -n "Time Logged in: "
read start_time

echo "SSH Commands (! to stop entry): "
ssh_cmds=""
echo -n "> "
read ssh_input

while [ "$ssh_input" != "!" ]
do
	if [ -z "$ssh_cmds" ]
	then
		ssh_cmds=">$ssh_input"
	else
		ssh_cmds="$ssh_cmds\n>$ssh_input"
	fi
	echo -n "> "
	read ssh_input
done

echo -n "Breach of data? (yes/no): "
read breach

echo -n "Services come back online (yes/no): "
read services_online

echo -n "Time Logged Out: "
read end_time

echo -e "\n\nPlace the following under special account notes with the following settings:"
echo -e "Priority: Unchecked\nType: Service (for Technical Support from any Department), or Sales (for Solutions)\nLegacy Created Date: Use the default by clicking the date to the right of the input field\nInformation: Note the account using the templates below and the information from your interaction with the server or service\nStart and End dates: Should both be set for the same day by clicking the values to the right of the input field\nPerpetual: Should be left unchecked\n"
echo -e "////////////////////////////////////////////////////////////////////////////////////
//  1) If kicked, please note why:
//    > $kicked 
//  2) Time of log in:
//    > $start_time 
//  3) If SSH, list Commands Ran and values altered 
//    > $ssh_cmds 
//  4) Did you notice any reason to believe breach of data?
//    *If Yes, notify a supervisor immediately!
//    > $breach 
//  4) Did Services come back online successfully?
//    > $services_online
//  5) Time of log out:
//    > $end_time
////////////////////////////////////////////////////////////////////////////////////"
