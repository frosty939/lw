#!/bin/bash

#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## Checks for hidden .ico files, moves them somewhere safe, then kills off the user processes
	## 
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# the usual clean up/optimization
	# better standardization
	# better failure checks
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

### Example of how to safely (hopefully) backup files to a single dir without worrying about duplicate file names
## (HINT: --suffix doesn't work for shit)
# find ./dir{1..5} -type f -exec mv -v --backup=numbered -t ./ {} +

# Building some useful lists for later
list_suspectFiles="$(find /home -not -path /home/hacked_files/* -name ".*.ico")"
list_suspectUsers=""

# Scrubbing out the actual users
for item in $list_suspectFiles; do
	list_suspectUsers="$list_suspectUsers $(echo $item | awk -F/ '{print $3}')"
done

for user in $list_suspectUsers; do
	echo "User: $user"
done
echo $list_suspectUsers

### Creating the quarantine dir, if it doesn't exist
mkdir -p /home/hacked_files ;

### moving all the files to quarantine
#(still needs work..)
find /home -not -path /home/hacked_files/* -name ".*.ico" -exec mv -vi --backup=numbered -t /home/hacked_files/ {} +

Check for Multiple tasks from minions
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	w
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


If multiple tasks exist, search for hidden .ico files
		2)	Find hidden .ico files			
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			find /home -not -path /home/hacked_files/* -name ".*.ico"
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

				
		3)	Securing the files			
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			mkdir -p /home/hacked_files ;
			find /home -not -path /home/hacked_files/* -name ".*.ico" -exec mv {} /home/hacked_files \;
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


		4)	Kill off bad users processes			
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			pkill -u 
			~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			(insert   s####   after the command for the user with the hidden ico files)
