#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
# Originally Written by: Quintin Bigelow
#            Updated by: Wayne Boyer
#=======================================================================================
	# Version 2.5 ----------------------------------------------------------------------
	## 2.5 (WIP, likely doesn't work right now)
	# adds ability to pass the screenshot name as an argument
	# adds automatic saving of link to clipboard
	# cleans up code format a bit
	# tweaks some of the functions to play a bit nicer
	# modified colorization (now uses a simple function)
	## 2.3
	# allow snapshotting of the USB Crash Cart Adapter window on the laptops
	## 2.2
	# send monshots to the new server (utilities.mon) and use rsync instead of FTP.
	#----------------------------------------------------------------------------------- 
	## Requirements:  imagemagick, xdotool, xclip 
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# help menu
	# general code cleanup
	# improve failure checks
	# add local logging
	# improve os detection
	# rebuild arguments as "case" instead of "if/elif"
	# fixy derpy behavior when running it via an alias (so it doesn't try to save tmp files in weird places and what not)
	# better comments/descriptions
	# check/install any missing tools
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	selection			###
}						###
###########################
### VARIABLES ###
	## detecting OS
		# Linux = Linux		OSX = Darwin
		detectOS="$(uname -s)"
	## adding colors (linux)
		if [ "detectOS" != "Darwin" ]; then
			red='\033[0;31m'	;		green='\033[0;32m'		;	yellow='\033[1;33m'
			clrColor='\033[0m'
			
			function red	{ printf "${red}${@}${clrColor}"	; }
			function yellow	{ printf "${yellow}${@}${clrColor}"	; }
			function green	{ printf "${green}${@}${clrColor}"	; }
		fi
	## where the script is hosted
		# filelocation="http://monshot.int.liquidweb.com/snapshot.sh"
		filelocation="https://git.liquidweb.com/bzimmerman/snapshot.sh/raw/master/snapshot.sh"		
	## Getting the working directory of where the script is saved
		scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	## Get the name of the script.
		scriptName="$(basename "$0")"
		
	## Monshot rsync INFO
		monIP="10.30.63.250"
		monUser="monshot"
		monPass="$scriptDir"/passwd-snapshot.txt
			#(useful for if you want to keep your $HOME clean)
			[ -f $monPass ] || monPass=$HOME/.passwords/passwd-snapshot.txt
	
### Window types we want to shot by default stored in an array
	declare -a WindowTypes="spice|FreeRDP|rdesktop|vnc|ikvm|redirection|Lantronix|Crash "


###########################################################################################
######  ┬─┐┌─┐┬ ┬┌┐┌┌─┐╔═╗┬ ┬┌─┐┌─┐┬┌─  ###################################################
######  ├┬┘└─┐└┬┘││││  ║  ├─┤├┤ │  ├┴┐  ###################################################
######  ┴└─└─┘ ┴ ┘└┘└─┘╚═╝┴ ┴└─┘└─┘┴ ┴  ###################################################
# Function to check if the rsync upload is successful or not ##############################
# If the rsync succeeds, it will delete the saved jpg file and give a monshot link. #######
# If the upload failed, it will say so and give a file location for the jpg.		#######
###########################################################################################
rsyncCheck () {
	# transfer was successful based on rsync command output
	rsyncResult="$(rsyncSave | grep -E 'sent\s+[0-9,.]+\s+bytes\s+received\s+[0-9,.]+\s+bytes')"
	if [ -n "$rsyncResult" ]; then
		green "File transfer successful!\n"
		yellow "Removing saved snapshot...\n"
		rm -vf "$(pwd)"/"$savedName"
		green "\nMonshot uploaded to:\n"
		echo -e "http://monshot.int.liquidweb.com/$(date +%m.%d.%y)/$savedName" | tee >(xclip -selection c)
		echo 
		### saving it to clipboard seperately from above (just in case it decides to fail for no reason)
		# echo -e "http://monshot.int.liquidweb.com/$(date +%m.%d.%y)/$savedName" | xclip -selection c
	else
		# if the transfer failed
		red "!!!!!WARNING!!!!!\n"
		red "FILE TRANSFER WAS UNSUCCESSFUL\n"
		red "Saved snapshot is located here: $(pwd)/$savedName\n"
		red "!!!!!WARNING!!!!!!\n"
		exit 1
	fi
}
### RSYNC Funtion ###
rsyncSave () {
	echo "$savedName"
	
	if [ "detectOS" = "Darwin" ]; then
		currentDay=$(date +"%m.%d.%y")
	else
		currentDay=$(date +%m.%d.%y)
	fi
	
	rsync -tv --password-file="$monPass" "$savedName" rsync://"$monUser"@"$monIP"/monshot/"$currentDay"/
}

# MAIN FUNCTION
# info goes here
selection() {
	if [ $WINDOWCOUNT -eq 1 ]; then
		# find windowname
		WinID=$(xdotool search --name "$WindowTypes" 2>/dev/null)
		WindowName=$(xdotool getwindowname $WinID 2>/dev/null)
		echo "Capturing Image of $WindowName"
		echo "Enter Name to Save Image as:"
		read saveName
		saveName=$(echo $saveName.$(date +%k.%M.%S)|sed -e 's/ //g')
		xdotool windowactivate $WinID 2>/dev/null
		import -window "$WinID" "$saveName".jpg
		savedName="$saveName".jpg
		rsyncCheck
	# If there is more than 1 window...
	elif [ $WINDOWCOUNT -gt 1 ]; then
		# Output to see window options.
		winList
		echo "Select window to capture:"
		# Get window choice.
		read selection
		# While selection is invalid, ask again.
		while [[ $selection = *[![:digit:]]* ]] || [[ "$(echo "$selection" | tr -c -d 0-9)" > $WINDOWCOUNT || $selection < 1 ]] || [[ "$selection " == "" ]]
		do
			echo "You're doing it wrong!"
			echo "Invalid Selection, try again."
			read selection
		done
		WinID=$(echo $WinIDs|cut -d' ' -f$selection)
		echo "Capturing Image of $(xdotool getwindowname $WinID 2>/dev/null)"
		echo "Enter Name to Save Image as:"
		read saveName
		saveName=$(echo $saveName.$(date +%k.%M.%S)|sed -e 's/ //g')
		xdotool windowactivate $WinID 2>/dev/null
		import -window "$WinID" "$saveName".jpg
		savedName="$saveName".jpg
		rsyncCheck
	# Otherwise there are no valid windows, exit with error.
	else
		echo "No ${WindowTypes[@]} windows found!"
		exit 1
	fi
}
### Get a list of window IDs
winList () {
		# find the windows that qualify
		WinIDs=""
		for WindowType in "${WindowTypes[@]}"; do
			WinIDs="$WinIDs$(xdotool search --name "$WindowType" 2>/dev/null)"
		done
		# window names from ids to make it human readable
		# these are outputted
		for WinID in $WinIDs; do
			xdotool getwindowname $WinID 2>/dev/null
		done|nl
}
### Update automagically ###
# Function to update snapshot.sh script.
updater () {
	# Get the script, fix permissions. that's it
	wget -qO "$scriptDir/snapshot.sh" $filelocation

	echo "Updating script..."
	chmod +x "$scriptDir/snapshot.sh"
	#   mv -f "$PWD/snapshot.sh.tmp" "$scriptDir/$scriptName"
		red "Re-running updated script!\n"
		# run the script again
		"$PWD/snapshot.sh"
		# but exit this one (the old version)
		exit 0
	else
		echo "Script is up to date, continuing..."
		rm -f "$PWD/snapshot.sh.tmp"
	fi
}
# If .snapshot exists where the script is then check if it has been updated today.
# If the .snapshot file has not been updated today or .snapshot does not exist
# then touch it to update/create it, and run the updater function to update script.
if [ -a "$scriptDir/.snapshot" ]; then
	# Mac OS X stat behaves differently, but this will produce same result
	if [ "detectOS" = "Darwin" ]; then
		CURDAY=$(date +"%b %d %Y")
		CURCHECK=$(stat -x .snapshot |grep Modify| awk '{print $3,$4,$6}')
	# linux
	else
		CURDAY=$(date +%Y-%m-%d)
		CURCHECK=$(stat .snapshot |grep Modify| awk '{print $2}')
	fi
	# if .snapshot is yesterday or older
	if [[ $CURDAY != "$CURCHECK" ]]; then
		touch "$scriptDir/.snapshot"
	#   updater
	fi
# if .snapshot doesn't exist
else
	touch "$scriptDir/.snapshot"
#   updater
fi
### END Update automagically ###


#### Flagged Options ####
# If script is run with -debug flag it will check for installed packages and running
# windows if there are any.
#
if [ "$1" != "" ]; then
	if [ "$1" = "-debug" ]; then
		## checking for windows
		echo "Checking for open Window ID:"
		winList
		echo "Checking Installed Packages:"
		
		if [ "detectOS" = "Darwin" ]; then
			port installed |egrep -i "(xdotool|vnc)"
		else
			## checking if deb
			if [ "$(which dpkg)" ]; then
				dpkg --list | egrep -i "(xdotool|vnc)"
			elif [ "$(which rpm)" ]; then
				rpm -qa | egrep -i "(xdotool|vnc)"
			else
				echo "I don't know what package manager you are using"
			exit 1
		fi
	fi
	exit 0
## Take a firefox snapshot:
# Note this won't work in OS X since we aren't running firefox though X11. oh well.
elif [ "$1" = "-firefox" ]; then
	if [ "detectOS" = "Darwin" ]; then
		echo "Sorry, firefox snapshotting will not work on OS X."
		exit 1
	else
		# redefine WindowTypes
		declare -a WindowTypes="Mozilla Firefox"
		# Extensible version:
		# declare -a WindowTypes=($(echo $@))
		# Count open windows.
		WINDOWCOUNT=$(xdotool search --name "Mozilla Firefox" 2>/dev/null | wc -l)
		# If there is exactly 1 window, then get the window ID and ask for saveName.
		# Once save name is input, bring the window to front (to avoid empty snapshot), and take snapshot.
		selection
		exit 0
	fi
# draw - this is being implemented mainly for firefox snapshots, but can be used for anything.
elif [ "$1" = "-draw" ]; then
	if [ "detectOS" = "Linux" ]; then
		# Checking for different screenshot utilities
		if type gnome-screenshot >/dev/null 2>&1 ; then
			if [ "$2" = "" ]; then
				echo "Enter Name to Save Image as:"
				read -r saveName
			fi
			saveName=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
			savedName=$saveName.jpg
			echo "Please select an area to capture."
			gnome-screenshot -af "$savedName"
			rsyncCheck
			exit 0
		elif type spectacal >/dev/null 2>&1 ; then
			if [ "$2" = "" ]; then
				echo "Enter Name to Save Image as:"
				read -r saveName
			fi
			saveName=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
			savedName=$saveName.jpg
			echo "Please select an area to capture."
			spectacal "$savedName"
			rsyncCheck
			exit 0
		elif type scrot >/dev/null 2>&1 ; then
			if [ "$2" = "" ]; then
				echo "Enter Name to Save Image as:"
				read -r saveName
			fi
			saveName=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
			savedName=$saveName.jpg
			echo "Please select an area to capture."
			scrot -s "$savedName"
			rsyncCheck
			exit 0
		elif type import >/dev/null 2>&1 ; then
			if [ "$2" = "" ]; then
				echo "Enter Name to Save Image as:"
				read -r saveName
			fi
			saveName=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
			savedName=$saveName.jpg
			echo "Please select an area to capture."
			import "$savedName"
			rsyncCheck
			exit 0
		fi
	elif [ "detectOS" = "Darwin" ]; then
		if [ "$2" = "" ]; then
			echo "Enter Name to Save Image as:"
			read -r saveName
		fi
		saveName=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
		savedName=$saveName.jpg
		echo "Please select a window or area to capture."
		screencapture -iW "$savedName"
		rsyncCheck
		exit 0
	else
		echo "Sorry, your system is currently not supported."
		exit 1
	fi
	
	# Script was run with a flag other than -debug or firefox, exit with error.
elif [ -n "$@" ]; then
		echo "You're doing it wrong!"
		echo "You shouldn't be passing this any arguments. Re-run without any."
		echo "Debug info can be found from the -debug flag"
		exit 1
	fi
	# fairly certain this exit is redundant since every option in the previous ifblock results in an exit
	exit 0
fi
# Count open windows.
# if there are 0 we do nothing, if more than 1 we ask which to snapshot
WINDOWCOUNT=0
# look through all the supported window types
for WindowType in ${WindowTypes[@]} ; do
		WINDOWADD=$(xdotool search --name $WindowType 2>/dev/null | wc -l)
		WINDOWCOUNT=$(( $WINDOWCOUNT + $WINDOWADD ))
	done
# If there is exactly 1 window, then get the window ID and ask for saveName.
# Once save name is input, bring the window to front (to avoid empty snapshot), and take snapshot.

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
main "$@"
exit 0
