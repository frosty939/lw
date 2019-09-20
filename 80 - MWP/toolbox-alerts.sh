#!/bin/bash

#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
# Created by:	Wayne Boyer
#=======================================================================================
	## Checks for hidden .ico files, moves them somewhere safe, then kills off the user processes
	## (Turning this into a general purpose mwp toolkit.. tis gonna be bonkers)
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# the usual clean up/optimization
	# better standardization
	# better failure checks
	# validation on targets/uid/input
	# drop output into clipboard and a tmp file (lasts a day or so?)
	# roll in the MWP python script so it can just directly pull/hit from there
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	userSetup			###
	meatGrinder "$@"	###
}						###
###########################
#------ error handling ----------
### If error, give up			#
#set -e							#
#- - - - - - - - - - - - - - - -#
### if error, do THING			#
# makes trap global 			#
#set -o errtrace				#
# 'exit' can be a func or cmd	#
#trap 'exit' ERR				#
#--------------------------------
###########################################################################################
######  ┬ ┬┌─┐┌─┐┬─┐╔═╗┌─┐┌┬┐┬ ┬┌─┐	#######################################################
######  │ │└─┐├┤ ├┬┘╚═╗├┤  │ │ │├─┘	#######################################################
######  └─┘└─┘└─┘┴└─╚═╝└─┘ ┴ └─┘┴  	#######################################################
# setting up user variables and what not ##################################################
###########################################################################################
function userSetup(){
	userName="$(cat $HOME/.passwords/billing.userName)"
	password="$(cat $HOME/.passwords/billing)"
}

###########################################################################################
######  ┌┬┐┌─┐┌─┐┌┬┐╔═╗┬─┐┬┌┐┌┌┬┐┌─┐┬─┐  ##################################################
######  │││├┤ ├─┤ │ ║ ╦├┬┘││││ ││├┤ ├┬┘  ##################################################
######  ┴ ┴└─┘┴ ┴ ┴ ╚═╝┴└─┴┘└┘─┴┘└─┘┴└─  ##################################################
# turns the  UID into a domain and gathers login info #####################################
###########################################################################################
function meatGrinder(){
# 	while :; do
# 		sleep 0.1
# 		printf "\n[MWP Target] UID: "
# 		read -n6 uid
# 		echo
# 		### Verifying a UID was entered ###
# 		if egrep "^[A-Z0-9]{6}" <<< $uid >/dev/null ;then
# 			## Turning UID into the default.mwp domain ##
# 			baseDomain="$(curl --silent \
# 								-u ${userName}:${password} \
# 								-H "Content-Type: application/json" \
# 								-H "Accept: application/json" \
# 								--data "{\"params\":{\"uniq_id\":\"$uid\"}}" \
# 								https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details \
# 								| jq -r '.domain')"
# 
# 			## Verifying an MWP domain ##
# 			if grep liquidwebsites.com <<< "$baseDomain" >/dev/null; then
# 				# Gathering login info for default.mwp domain #
# 				#(need to make a better check)
# 				targetDomain="default.mwp.$baseDomain"
# 				targetQuery="$(curl --silent \
# 									-u ${userName}:${password} \
# 									-H "Content-Type: application/json" \
# 									-H "Accept: application/json" \
# 									--data "{\"params\":{\"domain\":\"$targetDomain\"}}" \
# 									https://api.int.liquidweb.com/bleed/Billing/Subaccnt/list )"
# 
# 				targetIP="$(jq -r '.items[0] .ip'		<<< $targetQuery)"
# 				targetPW="$(jq -r '.items[0] .password'	<<< $targetQuery)"
# 				targetUID="$(jq -r '.items[0] .uniq_id' <<< $targetQuery)"
# echo "  Base Domain: $baseDomain"
# echo "     Base UID: $uid"
# echo "Target Domain: $targetDomain"
# echo "   Target UID: $targetUID"
# 				## auto login for UID from mwp list ###
# 				#(will eventually also drop payload/produce file/insert to clipboard..)
# 				# sshpass -p "$targetPW" ssh root@$targetIP 
# # sshpass -p ivT*yj8qo7orFe ssh root@209.59.176.35 -p14894 "$(declare -f payloadLoadAverage); payloadLoadAverage" | xclip -selection c	
# 			else
# 				echo "This doesn't look like a MWP domain. Try again"
# 			fi
# 		#----------------------------------------------
# 
# 		else
# 			printf "\nNot a UID. Try again.\n\n"
# 		fi
# 
# 
# 	done
	
	
	#**************
	# testing area
	#**************
	while :; do
		sleep 0.1
		printf "\n[MWP Target] UID: "
		read alertMessage
		echo
		# cleans up useless info from messgae
		alertMessage="${alertMessage//:9100/}"
		# grabs the base UID from full message
		baseUID="$(grep -Po "(?<=\()[A-Z0-9]{6}" <<< "${alertMessage}")"
		# gets what the actual issue is
		alertIssue="$(cut -d\( -f1 <<< "${alertMessage##* - }")"
			## Turning UID into the default.mwp domain ##
			baseDomain="$(curl --silent \
								-u ${userName}:${password} \
								-H "Content-Type: application/json" \
								-H "Accept: application/json" \
								--data "{\"params\":{\"uniq_id\":\"$baseUID\"}}" \
								https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details \
								| jq -r '.domain')"
					
			## Verifying an MWP domain ##
			if grep liquidwebsites.com <<< "$baseDomain" >/dev/null; then
				# Gathering login info for default.mwp domain #
				#(need to make a better check)
				targetDomain="default.mwp.$baseDomain"
				targetQuery="$(curl --silent \
									-u ${userName}:${password} \
									-H "Content-Type: application/json" \
									-H "Accept: application/json" \
									--data "{\"params\":{\"domain\":\"$targetDomain\"}}" \
									https://api.int.liquidweb.com/bleed/Billing/Subaccnt/list )"
									
				targetIP="$(jq -r '.items[0] .ip'		<<< $targetQuery)"
				targetPW="$(jq -r '.items[0] .password'	<<< $targetQuery)"
				targetUID="$(jq -r '.items[0] .uniq_id' <<< $targetQuery)"
echo "  Base Domain: $baseDomain"
echo "     Base UID: $uid"
echo "Target Domain: $targetDomain"
echo "   Target UID: $targetUID"
				## auto login for UID from mwp list ###
				#(will eventually also drop payload/produce file/insert to clipboard..)
				# sshpass -p "$targetPW" ssh root@$targetIP 
# sshpass -p ivT*yj8qo7orFe ssh root@209.59.176.35 -p14894 "$(declare -f payloadLoadAverage); payloadLoadAverage" | xclip -selection c	
			else
				echo "This doesn't look like a MWP domain. Try again"
			fi
		#----------------------------------------------
		
		else
			printf "\nNot a UID. Try again.\n\n"
		fi
			
		
	done	
}

###########################################################################################
######  ┬  ┌─┐┬ ┬┌┐┌┌─┐┬ ┬╔╗ ┌─┐┬ ┬  ######################################################
######  │  ├─┤│ │││││  ├─┤╠╩╗├─┤└┬┘  ######################################################
######  ┴─┘┴ ┴└─┘┘└┘└─┘┴ ┴╚═╝┴ ┴ ┴   ######################################################
# Holds the 'runbook' payloads  ###########################################################
###########################################################################################
#### Bombing Raid ###############
# checks nothing, just disables #
function bombingRaid(){			#
		:						#
}								#
#################################
### Formating stuff ###
function titleMain(){ printf "###H ${*}"; }
function titleSec (){ printf "[${*}]"; }
format_codeBlock="$(printf %3s | tr " " "\`")"

#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#|||||||| Disk Use ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
function payloadDiskUse(){
#--------------------------------------------------
initialLogin="$(printf %b "
> Reported with: Disk Use
> Wiki Used:   http://sites-wiki.int.liquidweb.com/display/csops/VPS-+Low+Disk+Space+alert

$(titleMain Initial Server Stats)
**| ${format_codeBlock}
===== $(hostname) =====\n
$(titleSec Active Sessions)
$(w)\n\n
$(titleSec Disk Use)
$(df -h|grep -v docker )\n\n
$(titleSec RAM Use)
$(free -h||free -m)
${format_codeBlock}\n\n")"

printf "\nPurging Wraith & Pruning Docker (this may take some time)\n"
find /home/wraith -mtime +5 -exec rm {} 2>/dev/null \;
docker system prune -fa

printf %b "${initialLogin}"
printf %b "\n\n\n$(titleMain Action\(s\) Taken)
** Wraith Purged
**| ${format_codeBlock}
$(printf %s 'find /home/wraith -mtime +5 -exec rm {} \;')
${format_codeBlock}\n
** Docker Pruned
**| ${format_codeBlock}
$(printf %s 'docker system prune -fa')
${format_codeBlock}\n
$(titleMain Disk Usage)
** Logs over 500M
**| ${format_codeBlock}
$(find / -not -path /proc -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +500M -exec ls -sh {} \; | awk '{printf "%6s\t%s\n",$1,$2}')
${format_codeBlock}
** Directories over 1G:
**| ${format_codeBlock}\n";
dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {printf "%6s\t%s\n",$1,$2}' | sort -rn);
printf %b "$(
	for i in $(echo "$dirs" | awk '{print $2}');do
		if [ "$(echo "$dirs"| egrep $i -c)" == 1 ];then 
			echo "$dirs"| egrep $i
		fi
	done)
${format_codeBlock}\n\n"
	
printf %b "
$(titleMain Ending Disk Space)
**| ${format_codeBlock}
$(df -h | grep -v docker)
${format_codeBlock}\n\n\n"

}

#"
# ^^ the line above here is just to de-derp atom apparently something is confusing it's colorization
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#|||||||| Load Average ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
function payloadLoadAverage() {
#--------------------------------------------------
### Intial Login (from disk.use.sh) ###
initialLogin="$(printf %b "\
> Reported with: Load Average\n\
> Wiki Used: http://sites-wiki.int.liquidweb.com/display/csops/NodeLoadAverage

$(titleMain Initial Server Stats)\n\
**| ${format_codeBlock}\n\
===== $(hostname) =====\n\
$(titleSec Active Sessions)\n\
$(w)\n\
\n$(titleSec Disk Use)\n\
$(df -h|grep -v docker )\n\
\n$(titleSec RAM Use)\n\
$(free -h||free -m)\n\
${format_codeBlock}\n\n")";

### Doing the things ###
## Building some useful lists for later
list_suspectFiles="$(find /home -not -path /home/hacked_files/* -name ".*.ico")";
list_suspectUsers="$( (awk -F "/" '{print $3}' | sort -u) <<< "$list_suspectFiles")";
## Creating the quarantine dir, if it doesn't exist
	mkdir -p /home/hacked_files ;
## moving all the files to quarantine
	# find /home -not -path /home/hacked_files/* -name ".*.ico" -exec mv -v --backup=numbered -t /home/hacked_files {} +
	mv -v --backup=numbered -t /home/hacked_files $list_suspectFiles 2>/dev/null;
## Killing baddies
	for user in $list_suspectUsers; do
		pkill -u $user;
	done;

### Notes Output ###
printf %s "${initialLogin}";
printf %b "\n\
$(titleMain Action\(s\) Taken)\n\
** Searched for hidden .ico files\n\
**| ${format_codeBlock}\n\
$(printf %s 'list_suspectFiles="$(find /home -not -path /home/hacked_files/* -name ".*.ico")"')\n\
$(printf %s 'list_suspectUsers="$( (awk -F "/" '{print $3}' | sort -u) <<< "$list_suspectFiles")"')\n\
${format_codeBlock}\n\
** Moved suspect files to \`/home/hacked_files\`\n\
**| ${format_codeBlock}\n\
$(printf %s 'mv -v --backup=numbered -t /home/hacked_files $list_suspectFiles')\n\
${format_codeBlock}\n\
** Killed off sketchy processes\n\
**| ${format_codeBlock}\n\
$(printf %s 'for user in $list_suspectUsers; do pkill -u $user;done')\n\
${format_codeBlock}\n\

$(titleMain Suspect Lists)\n\
** Users\n\
**| ${format_codeBlock}\n\
$list_suspectUsers \n\
${format_codeBlock}\n\
** Files\n\
**| ${format_codeBlock}\n\
$list_suspectFiles \n\
${format_codeBlock}\n\

$(titleMain Ending Server Stats)\n\
**| ${format_codeBlock}\n\
$(titleSec Active Sessions)\n\
$(w)\n\
${format_codeBlock}\n";
}

#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# stuff below here was from the original alert.high.load.sh 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P0: FULL ONE-LINER
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# sudo su -;function titleMain (){ printf "###H \033[1;36m${*}\033[0m"; };function titleSec  (){ printf "[\033[34m${*}\033[0m]"; };format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";initialLogin="$(printf %b "\n> Reported with: Load Average\n> Wiki Used: http://sites-wiki.int.liquidweb.com/display/csops/NodeLoadAverage\n\n$(titleMain Initial Server Stats)\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n$(titleSec Active Sessions)\n$(w)\n\n$(titleSec Disk Use)\n$(df -h|grep -v docker )\n\n$(titleSec RAM Use)\n$(free -h||free -m)\n${format_codeBlock}\n\n")";printf "\n\nSearching for hidden .ico files\n(\033[34mThis may take a while\033[0m)\n\n";list_suspectFiles="$(find /home -not -path /home/hacked_files/* -name ".*.ico")";list_suspectUsers="$( (awk -F "/" '{print $3}' | sort -u) <<< "$list_suspectFiles")";mkdir -p /home/hacked_files ;mv -v --backup=numbered -t /home/hacked_files $list_suspectFiles ;for user in $list_suspectUsers; do pkill -u $user;done;printf "\n${format_noteBlock}\n\n\n";printf %b "${initialLogin}";printf %b "\n\n$(titleMain Action\(s\) Taken)\n** Searched for hidden .ico files\n**| ${format_codeBlock}\n$(printf %s 'list_suspectFiles="$(find /home -not -path /home/hacked_files/* -name ".*.ico")"')\n$(printf %s 'list_suspectUsers="$( (awk -F "/" '{print $3}' | sort -u) <<< "$list_suspectFiles")"')\n${format_codeBlock}\n** Moved suspect files to \`/home/hacked_files\`\n**| ${format_codeBlock}\n$(printf %s 'mv -v --backup=numbered -t /home/hacked_files $list_suspectFiles')\n${format_codeBlock}\n** Killed off sketchy processes\n**| ${format_codeBlock}\n$(printf %s 'for user in $list_suspectUsers; do pkill -u $user;done')\n${format_codeBlock}\n\n$(titleMain Suspect Lists)\n** Users\n**| ${format_codeBlock}\n$list_suspectUsers \n${format_codeBlock}\n** Files\n**| ${format_codeBlock}\n$list_suspectFiles \n${format_codeBlock}\n\n$(titleMain Ending Server Stats)\n**| ${format_codeBlock}\n$(titleSec Active Sessions)\n$(w)\n${format_codeBlock}\n";printf "\n\n\n${format_noteBlock}\n"


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P1: READABLE
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Example of how to safely (hopefully) backup files to a single dir without worrying about duplicate file names
## (HINT: --suffix doesn't work for shit)
# find ./dir{1..5} -type f -exec mv -v --backup=numbered -t ./ {} +
# find /home -not -path /home/hacked_files/* -name ".*.ico" -exec mv -v --backup=numbered -t /home/hacked_files {} +

# sudo su -
# ### Intial Login (from disk.use.sh) ###
# # needs to get checked #
# function titleMain (){ printf "###H \033[1;36m${*}\033[0m"; };
# function titleSec  (){ printf "[\033[34m${*}\033[0m]"; };
# 
# format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";
# format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";
# initialLogin="$(printf %b "\n
# 				> Reported with: Load Average\n
# 				> Wiki Used: http://sites-wiki.int.liquidweb.com/display/csops/NodeLoadAverage\n\n
# 
# 				$(titleMain Initial Server Stats)\n
# 				**| ${format_codeBlock}\n
# 					===== $(hostname) =====\n\n
# 					$(titleSec Active Sessions)\n
# 						$(w)\n
# 					\n$(titleSec Disk Use)\n
# 						$(df -h|grep -v docker )\n
# 					\n$(titleSec RAM Use)\n
# 						$(free -h||free -m)\n
# 				${format_codeBlock}\n\n")";
# 
# ### Doing the things ###
# 	## Building some useful lists for later
# 	printf "\n\n
# 		Searching for hidden .ico files\n
# 		(\033[34mThis may take a while\033[0m)\n\n";
# 	list_suspectFiles="$(find /home -not -path /home/hacked_files/* -name ".*.ico")";
# 	list_suspectUsers="$( (awk -F "/" '{print $3}' | sort -u) <<< "$list_suspectFiles")";
# 	## Creating the quarantine dir, if it doesn't exist
# 		mkdir -p /home/hacked_files ;
# 	## moving all the files to quarantine
# 		# find /home -not -path /home/hacked_files/* -name ".*.ico" -exec mv -v --backup=numbered -t /home/hacked_files {} +
# 		mv -v --backup=numbered -t /home/hacked_files $list_suspectFiles ;
# 	## Killing baddies
# 		for user in $list_suspectUsers; do
# 			pkill -u $user;
# 		done;
# 
# ### Notes Output ###
# 	printf "\n${format_noteBlock}\n\n\n"
# 
# 	printf %b "${initialLogin}";
# 	printf %b "\n\n
# 		$(titleMain Action\(s\) Taken)\n
# 			** Searched for hidden .ico files\n
# 				**| ${format_codeBlock}\n
# 					$(printf %s 'list_suspectFiles="$(find /home -not -path /home/hacked_files/* -name ".*.ico")"')\n
# 					$(printf %s 'list_suspectUsers="$( (awk -F "/" '{print $3}' | sort -u) <<< "$list_suspectFiles")"')\n
# 				${format_codeBlock}\n
# 			** Moved suspect files to \`/home/hacked_files\`\n
# 				**| ${format_codeBlock}\n
# 					$(printf %s 'mv -v --backup=numbered -t /home/hacked_files $list_suspectFiles')\n
# 				${format_codeBlock}\n
# 			** Killed off sketchy processes\n
# 				**| ${format_codeBlock}\n
# 					$(printf %s 'for user in $list_suspectUsers; do pkill -u $user;done')\n
# 				${format_codeBlock}\n\n
# 
# 		$(titleMain Suspect Lists)\n
# 			** Users\n
# 				**| ${format_codeBlock}\n
# 					$list_suspectUsers \n
# 				${format_codeBlock}\n
# 			** Files\n
# 				**| ${format_codeBlock}\n
# 					$list_suspectFiles \n
# 				${format_codeBlock}\n\n
# 
# 		$(titleMain Ending Server Stats)\n
# 			**| ${format_codeBlock}\n
# 				$(titleSec Active Sessions)\n
# 					$(w)\n
# 			${format_codeBlock}\n
# 		";
# 
# 	printf "\n\n\n${format_noteBlock}\n"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main "$@"
