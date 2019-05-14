#!/bin/bash
#Written by Quintin Bigelow
#Updated by Russ Long
#Version 2.3
#2.3 is updated to allow snapshotting of the USB Crash Cart Adapter window on the laptops
#2.2 is updated to send monshots to the new server (utilities.mon) and use rsync instead of FTP.
#requires imagemagick, xdotool
###############################################################################
#####VARIABLES#####
#where is the file?
filelocation="http://monshot.int.liquidweb.com/snapshot.sh"
#detect OS, because they behave slightly differently
#Linux=Linux, OSX=Darwin
OS="$(uname -s)"
# Get the working directory from where the script is running from (where it is saved).
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get the name of the script.
SNAME="$(basename "$0")"
#we will add some colors only for linux though
if  [ "$OS" != "Darwin" ]; then
    Red='\e[0;31m'
    Green='\e[0;32m'
    Yellow='\e[1;33m'
    NoColor='\e[0m'
fi
#Monshot rsync INFO
HOST="10.30.63.250"
USER="monshot"
PASS=$DIR/passwd-snapshot.txt
#Window types we want to shot by default stored in an array
declare -a WindowTypes="spice|FreeRDP|rdesktop|vnc|ikvm|redirection|Lantronix|Crash "
#####FUNCTIONS#####
###Upload Check###
# Function to check if the rsync upload is successful or not, if it is
# it will delete the saved jpg file and give a monshot link to the jpg.
# If the upload failed, it will say so and give a file location for the jpg.
rsynccheck () {
    #transfer was successful based on rsync command output
    rsyncresult="$(rsyncsave | grep -E 'sent\s+[0-9,.]+\s+bytes\s+received\s+[0-9,.]+\s+bytes')"
    if [ -n "$rsyncresult" ]
    then
        echo -e "$Green""File transfer successful!""$NoColor"
        echo -e "$Yellow""Removing saved snapshot...""$NoColor"
        rm -vf "$(pwd)"/"$savedname"
        echo -e "$Green""\nMonshot uploaded to:""$NoColor"
        echo -e "http://monshot.int.liquidweb.com/$(date +%m.%d.%y)/$savedname\n"
		#saving it to clipboard
		echo -e "http://monshot.int.liquidweb.com/$(date +%m.%d.%y)/$savedname" | xclip -selection c
    else
        #if the transfer failed
        echo -e "$Red""!!!!!WARNING!!!!!""$NoColor"
        echo -e "$Red""FILE TRANSFER WAS UNSUCCESSFUL""$NoColor"
        echo -e "$Red""Saved snapshot is located here: $(pwd)/$savedname""$NoColor"
        echo -e "$Red""!!!!!WARNING!!!!!!""$NoColor"
        exit 1
    fi
}
###RSYNC Funtion###
rsyncsave () {
    echo "$savedname"
        if [ "$OS" = "Darwin" ]
        then
                CURDAYRS=$(date +"%m.%d.%y")
        #linux
        else
                CURDAYRS=$(date +%m.%d.%y)
        fi
    rsync -tv --password-file="$PASS" "$savedname" rsync://"$USER"@"$HOST"/monshot/"$CURDAYRS"/
}
#MAIN FUNCTION
#info goes here
selection() {
        if [ $WINDOWCOUNT -eq 1 ]
        then
                #find windowname
                WinID=`xdotool search --name "$WindowTypes" 2>/dev/null`
                WindowName=`xdotool getwindowname $WinID 2>/dev/null`
                echo "Capturing Image of $WindowName"
                echo "Enter Name to Save Image as:"
                read savename
                savename=$(echo $savename.`date +%k.%M.%S`|sed -e 's/ //g')
                xdotool windowactivate $WinID 2>/dev/null
                import -window "$WinID" "$savename".jpg
                savedname="$savename".jpg
                rsynccheck
        # If there is more than 1 window...
        elif [ $WINDOWCOUNT -gt 1 ]
        then
                # Output to see window options.
                winlist
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
                WinID=`echo $WinIDs|cut -d' ' -f$selection`
                echo "Capturing Image of `xdotool getwindowname $WinID 2>/dev/null`"
                echo "Enter Name to Save Image as:"
                read savename
                savename=$(echo $savename.`date +%k.%M.%S`|sed -e 's/ //g')
                xdotool windowactivate $WinID 2>/dev/null
                import -window "$WinID" "$savename".jpg
        savedname="$savename".jpg
                rsynccheck
        # Otherwise there are no valid windows, exit with error.
        else
                echo "No ${WindowTypes[@]} windows found!"
                exit 1
        fi
}
###Get a list of window IDs
winlist () {
        #find the windows that qualify
        WinIDs=""
        for WindowType in "${WindowTypes[@]}"
        do
                WinIDs="$WinIDs`xdotool search --name "$WindowType" 2>/dev/null`"
        done
        #window names from ids to make it human readable
        #these are outputted
        for WinID in $WinIDs
        do
                xdotool getwindowname $WinID 2>/dev/null
        done|nl
}
###Update automagically###
# Function to update snapshot.sh script.
updater () {
    # Get the script, save it to .tmp.
    wget -O snapshot.sh.tmp $filelocation > /dev/null 2>&1
    # Variable to store password from the current script.
    #   TMPPASS=(`echo $PASSWD|sed 's/"//g'`)
    # Modifies PASSWD in the .tmp script with the password stored in the TMPPASS variable.
    #   sed -i "s/^PASSWD=\"\"/PASSWD=\"$TMPPASS\"/" snapshot.sh.tmp
    # If there is a difference between the current script and the newly gotten
    # .tmp script, update the script by moving the new, .tmp one in to the
    #place of the current one and adding executable permissions, otherwise
    #just remove the .tmp file and continue.
    if [[ -n $(diff "$DIR/$SNAME" "$PWD/snapshot.sh.tmp") ]]
    then
        echo "Newer version found!"
        echo "Updating script..."
    #   chmod +x "$PWD/snapshot.sh.tmp"
    #   mv -f "$PWD/snapshot.sh.tmp" "$DIR/$SNAME"
        echo -e "$Red""Re-running updated script!""$NoColor"
        #run the script again
        "$PWD/snapshot.sh"
        #but exit this one (the old version)
        exit 0
    else
        echo "Script is up to date, continuing..."
        rm -f "$PWD/snapshot.sh.tmp"
    fi
}
# If .snapshot exists where the script is then check if it has been updated today.
# If the .snapshot file has not been updated today or .snapshot does not exist
# then touch it to update/create it, and run the updater function to update script.
if [ -a "$DIR/.snapshot" ]
then
    #Mac OS X stat behaves differently, but this will produce same result
    if [ "$OS" = "Darwin" ]
    then
        CURDAY=$(date +"%b %d %Y")
        CURCHECK=$(stat -x .snapshot |grep Modify| awk '{print $3,$4,$6}')
    #linux
    else
        CURDAY=$(date +%Y-%m-%d)
        CURCHECK=$(stat .snapshot |grep Modify| awk '{print $2}')
    fi
    #if .snapshot is yesterday or older
    if [[ $CURDAY != "$CURCHECK" ]]
    then
        touch "$DIR/.snapshot"
    #   updater
    fi
#if .snapshot doesn't exist
else
    touch "$DIR/.snapshot"
#   updater
fi
### END Update automagically###
####Flagged Options####
# If script is run with -debug flag it will check for installed packages and running
# windows if there are any.
#
if [ "$1" != "" ]
then
    if [ "$1" = "-debug" ]
    then
    #check for windows
    echo "Checking for open Window ID:"
    winlist
        echo "Checking Installed Packages:"
        if [ "$OS" = "Darwin" ]
        then
            port installed |egrep -i "(xdotool|vnc)"
        else
            #check for deb
            if [ "$(which dpkg)" ]
            then
            dpkg --list | egrep -i "(xdotool|vnc)"
        elif [ "$(which rpm)" ]
        then
            rpm -qa | egrep -i "(xdotool|vnc)"
        else
            echo "I don't know what package manager you are using"
            exit 1
        fi
    fi
    exit 0
    #Take a firefox snapshot:
    #Note this won't work in OS X since we aren't running firefox though X11. oh well.
	elif [ "$1" = "-firefox" ]
    then
        if [ "$OS" = "Darwin" ]
        then
                        echo "Sorry, firefox snapshotting will not work on OS X."
                        exit 1
                else
                        #redefine WindowTypes
                        declare -a WindowTypes="Mozilla Firefox"
                        #Extensible version:
                        #declare -a WindowTypes=(`echo $@`)
                        # Count open windows.
                        WINDOWCOUNT=$(xdotool search --name "Mozilla Firefox" 2>/dev/null | wc -l)
                        # If there is exactly 1 window, then get the window ID and ask for savename.
                        # Once save name is input, bring the window to front (to avoid empty snapshot), and take snapshot.
                        selection
                        exit 0
                fi
    #draw - this is being implemented mainly for firefox snapshots, but can be used for anything.
	elif [ "$1" = "-draw" ]
    then
        if [ "$OS" = "Linux" ]
            then
            # Checking for different screenshot utilities
            if type gnome-screenshot >/dev/null 2>&1
            then
				if [ "$2" = "" ]; then
	                echo "Enter Name to Save Image as:"
	                read -r savename
				fi
                savename=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
                savedname=$savename.jpg
                echo "Please select an area to capture."
                gnome-screenshot -af "$savedname"
                rsynccheck
                exit 0
            elif type spectacal >/dev/null 2>&1
            then
				if [ "$2" = "" ]; then
	                echo "Enter Name to Save Image as:"
	                read -r savename
				fi
                savename=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
                savedname=$savename.jpg
                echo "Please select an area to capture."
                spectacal "$savedname"
                rsynccheck
                exit 0
            elif type scrot >/dev/null 2>&1
            then
				if [ "$2" = "" ]; then
	                echo "Enter Name to Save Image as:"
	                read -r savename
				fi
                savename=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
                savedname=$savename.jpg
                echo "Please select an area to capture."
                scrot -s "$savedname"
                rsynccheck
                exit 0
            elif type import >/dev/null 2>&1
            then
				if [ "$2" = "" ]; then
	                echo "Enter Name to Save Image as:"
	                read -r savename
				fi
                savename=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
                savedname=$savename.jpg
                echo "Please select an area to capture."
                import "$savedname"
                rsynccheck
                exit 0
            fi
        elif [ "$OS" = "Darwin" ]
        then
			if [ "$2" = "" ]; then
				echo "Enter Name to Save Image as:"
				read -r savename
			fi
			savename=$(echo "$2"."$(date +%k.%M.%S)"|sed -e 's/ //g')
            savedname=$savename.jpg
            echo "Please select a window or area to capture."
            screencapture -iW "$savedname"
            rsynccheck
            exit 0
        else
            echo "Sorry, your system is currently not supported."
            exit 1
        fi
    # Script was run with a flag other than -debug or firefox, exit with error.
    elif [ -n "$@" ]
    then
        echo "You're doing it wrong!"
        echo "You shouldn't be passing this any arguments. Re-run without any."
        echo "Debug info can be found from the -debug flag"
        exit 1
    fi
    #fairly certain this exit is redundant since every option in the previous ifblock results in an exit
    exit 0
fi
# Count open windows.
# if there are 0 we do nothing, if more than 1 we ask which to snapshot
WINDOWCOUNT=0
#look through all the supported window types
for WindowType in ${WindowTypes[@]}
do
        WINDOWADD=`xdotool search --name $WindowType 2>/dev/null | wc -l`
        WINDOWCOUNT=$(( $WINDOWCOUNT + $WINDOWADD ))
done
# If there is exactly 1 window, then get the window ID and ask for savename.
# Once save name is input, bring the window to front (to avoid empty snapshot), and take snapshot.
selection
exit 0
