#!/bin/bash
#-----
# should probably add a timeout so it doesn't run forever

read -p "How often  should we refresh [5]: " hz
	: ${hz:=5}
printf "\nRefreshing Firefox Windows every [$hz] seconds.\n"


idFirefox=$(xdotool search --name "Mozilla Firefox")

while : ; do    #tells it to loop until stopped

        for firefoxWindow in $idFirefox; do
                sleep 0.25      #required for slow comp :(
                # if you want to activate the window first
                #xdotool windowactivate $firefoxWindow key F5

                # if you just want ff to refresh
                xdotool key --window $firefoxWindow F5
        done

        #setting the repeat time
        sleep $hz

done
