#!/bin/bash
#######################################################################
#### To run script, start with /home/wayne/scriptsB/backupStart.sh ####
#######################################################################
		#
		#*************** NEED TO DO/ADD ***********************
		#===sync
		# scripts to/from IcePick
		# '/media/wayne/IcePick/-- TOOLS --/~ commands, scripts, tricks, etc/LW/scripts'
		#===add
		# syncing of scripts to test vm(s)
		# ("done" via backupStart.sh script) drop into tmux session
		# existing backups && if zipped up (except the newest)
		# timer && failure checking
		# current log rotate
		# current log size check
		#--backup of misc files
		#		fstab		iptables
		#===fix
		# derpy formating of rsync command variable
		# logging.. goes to the wrong place now because of permission juggling
		# backing up of the current output log (it doesn't output the full output log for the current backup in the backup dir)
		#===check for
		# is tmux session is actually complete before killing it
		# backup drive is mounted
		# backup drive is healthy
		# room available on backup drive
		# if failed, print red
		#===test
		# anything lost if .cache is ignored all together?
		#===undecided
		# tarball
		#***********************************************
		#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#### RUN function #################
###################################
function main(){				###
	# backupHome		#||	exit 10	###
	pullIcePick		#||	exit 20	###
	dailyNotes		#||	exit 30	###
	roomba			#|| exit 40 ###
#	timepiece		#||	exit 99	###
}								###
###################################
#------ error handling ----------
### If error, give up			#
#set -e							#
#- - - - - - - - - - - - - - - -#
### if error, do THING			#
# makes trap global 			#
# (works in functions)			#
#set -o errtrace				#
# 'exit' can be a func or cmd	#
#trap 'exit' ERR				#
#--------------------------------

#-------- Colors! --------------
red='\e[0;31m'		;	blue='\e[0;34m'
green='\e[0;32m'

normal='\e[0m'

#-------------------------------
# so you get your normal shell stuff in the tmux session
source /etc/bashrc


#################################################################################
#####  ╦ ╦┌─┐┌┬┐┌─┐  ############################################################
#####  ╠═╣│ ││││├┤   ############################################################
#####  ╩ ╩└─┘┴ ┴└─┘  ############################################################
# backing up all important home dir stuff (hopefully) ###########################
#################################################################################
function backupHome(){
	if [[ -d /media/wayne/backups ]]; then
		local backupTime="$(date +"%Y%m%d_%H")"
		#rLog_Home="/var/log/backupHome.log-$backupTime"
		rLog_Home="/home/wayne/logs/backupHome.log-$backupTime"
		src_Home="/home/wayne/"
		dst_Home="/media/wayne/backups/system/wayne-$backupTime"
		## backing up the files, ignoring the fat ones ##
		local rsyncCommand="rsync -a	--stats \
										--progress \
										--delete \
										--exclude=.atom \
										--exclude=autokey \
										--exclude=.local/share/Trash \
										--exclude=Downloads \
										--exclude=snap \
										--exclude=.mozilla \
										--exclude=.cache/mozilla \
										--exclude=.cache/google-chrome \
										--log-file=$rLog_Home"
		## making the log a little clearer (hopefully) ##
		printf "\t[START]\t\t -HOME- \t\t$(date)\t\t\n" | tee -a $rLog_Home
		$rsyncCommand "$src_Home" "$dst_Home"	||	exit 25
		printf "\t[ END ]\t\t -HOME- \t\t[$(date)]\t\t\n" | tee -a $rLog_Home
	fi
}

#################################################################################
#####  ╦┌─┐┌─┐╔═╗┬┌─┐┬┌─  #######################################################
#####  ║│  ├┤ ╠═╝││  ├┴┐  #######################################################
#####  ╩└─┘└─┘╩  ┴└─┘┴ ┴  #######################################################
# pulling any new stuff from IcePick to /home/wayne/scriptsB ####################
#################################################################################
function pullIcePick(){
## making sure IcePick is attached before wasting time
	if [[ -d /media/wayne/IcePick/PortableApps ]]; then
		#rLog_IcePick="/var/log/backupIcePick.log"
		rLog_IcePick="/home/wayne/logs/backupIcePick.log"
		#had to be done this way(?) making the path names hard to navigate made them... hard to navigate >.>
		src_IcePick="$(cat <<-'EOF'
							/media/wayne/IcePick/-- TOOLS --/~ commands, scripts, tricks, etc/LW/scripts/
							EOF
					)"
		dst_IcePick="/home/wayne/scriptsB/"

		## backing up the files, ignoring the fat ones ##
		local rsyncCommand="rsync -a	--stats \
										--progress \
										--delete \
										--log-file=$rLog_IcePick
							"

		## making the log a little clearer (hopefully) ##
		printf "\t[START]\t\t -IcePick- \t\t$(date)\t\t\n" | tee -a $rLog_IcePick
		$rsyncCommand "$src_IcePick" "$dst_IcePick"	||	exit 25
		printf "\t[ END ]\t\t -IcePick- \t\t[$(date)]\t\t\n" | tee -a $rLog_IcePick
	fi
}

#################################################################################
#####  ╔╦╗┬┌┬┐┌─┐┌─┐┬┌─┐┌─┐┌─┐  #################################################
#####   ║ ││││├┤ ├─┘│├┤ │  ├┤   #################################################
#####   ╩ ┴┴ ┴└─┘┴  ┴└─┘└─┘└─┘  #################################################
# checks when syncs last ran, if successful, and if it should be moved ##########
# (meaning it'll move backups based ona a schedule. monthly, weekly, etc.) ######
#################################################################################
function timepiece(){
:
}

#################################################################################
######  ┌┬┐┌─┐┬┬ ┬ ┬╔╗╔┌─┐┌┬┐┌─┐┌─┐  ############################################
######   ││├─┤││ └┬┘║║║│ │ │ ├┤ └─┐  ############################################
######  ─┴┘┴ ┴┴┴─┘┴ ╝╚╝└─┘ ┴ └─┘└─┘  ############################################
# moves my daily notes for tickets and whatnot into it's own folder #############
#################################################################################
function dailyNotes() {
	###
	if [[ -d /media/wayne/IcePick ]]; then
		### variables
		src_IcePick_dailyNotes="/media/wayne/IcePick/-- TOOLS --/~ commands, scripts, tricks, etc/LW/tempNotes.d/"
		dst_IcePick_dailyNotes="/media/wayne/IcePick/-- TOOLS --/~ commands, scripts, tricks, etc/LW/tempNotes.d/notTodays/$(date +%Y-%m-%d)/"
		rLog_dailyNotes="/home/wayne/logs/dailyNotes.log"
		### clockworks
		mkdir -p "$dst_IcePick_dailyNotes"
		
		## finds all the files, and prints out just their name
		printf "\t[START]\t\t -DailyNotes- \t\t[$(date)]\t\t\n" | tee -a $rLog_dailyNotes
		#find "$src_IcePick_dailyNotes" -maxdepth 1 -type f -regex "$src_IcePick_dailyNotes"/[0-9]+.* | rev |awk -F/ '{print $1}' |rev	# ~useful for grabbing just the file names (but there are better ways)
		find "$src_IcePick_dailyNotes" -maxdepth 1 -type f -regex "$src_IcePick_dailyNotes"[0-9]+.* -exec mv {} "$dst_IcePick_dailyNotes" \;
		printf "\t[ END ]\t\t -DailyNotes- \t\t[$(date)]\t\t\n" | tee -a $rLog_dailyNotes
	fi
	###
	
	
	
}


#################################################################################
######  ┬─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐  #####################################################
######  ├┬┘│ ││ ││││├┴┐├─┤  #####################################################
######  ┴└─└─┘└─┘┴ ┴└─┘┴ ┴  #####################################################
# cleans up rando  tash files that accumulate each day ##########################
#################################################################################
function roomba() {
	### Purging rando ipmi applet files leftover ###
	find /home/wayne/Downloads/ -maxdepth 1 -type f \( -name "*.jnlp" -or -name "?nconfirmed*.crdownload" \) -delete
}








#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main || echo "[$(date +%Y-%m%d)] superFail" >> /home/wayne/logs/backupLog.error
