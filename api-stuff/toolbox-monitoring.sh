#!/bin/bash
#doom

#                 _            
#                | |           
#   _ __ __ _  __| | __ _ _ __ 
#  | '__/ _` |/ _` |/ _` | '__|
#  | | | (_| | (_| | (_| | |   
#  |_|  \__,_|\__,_|\__,_|_|   
#
#  ███████╗██╗    ██╗███████╗███████╗██████╗ ███████╗██████╗ 
#  ██╔════╝██║    ██║██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗
#  ███████╗██║ █╗ ██║█████╗  █████╗  ██████╔╝█████╗  ██████╔╝
#  ╚════██║██║███╗██║██╔══╝  ██╔══╝  ██╔═══╝ ██╔══╝  ██╔══██╗
#  ███████║╚███╔███╔╝███████╗███████╗██║     ███████╗██║  ██║
#  ╚══════╝ ╚══╝╚══╝ ╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝
#                                                            

#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
# Created by:	Wayne Boyer
#=======================================================================================
	### (This has been slowly morphing as I progress, likely going to end up a "Monitoring Toolbox" instead)
	## Grabs the list of UIDs from radar (or from a file)
	## Turns them into account numbers
	## Checks if account/asset is suspended/TOSViolation/Tear-Down or not, then disables monitoring
	# 
	# how to hit the API		curl -u USER:PASS --silent 'API URL' --data '{"params":{"accnt":"account_status"}}'
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	### GEMERAL
	# start menu
	# clean this garbage up
	# needs optimization.. everywhere..
	# check if the password/username files exist, if not, create them
	# time check (to make sure its not running too often)
	# logging
	# Validate disabled (should probably avoid, for now, to limit api calling?)
	# reduce number of API calls. just need to recall from array
	# NEED MOAR VALIDATION. UBER SAUCE DANGER-ZONE
	### FANCY
	# Temporary (timed) disabling of monitoring [SUPER LOGS REQUIRED]
	# Time checks to determine the most efficient order to check (example: ~0600-0800 = check suspension | !~0600-0800 = check teardown)
	### MISC
	# fix the janky curlCMD here doc nonsense
	# Expand into a full suite of monitoring tools?
	# Set Monitoring to: Un-Managed / Managed / Fully-Managed
	# Enable/Disable monitoring for speciifc serivces
	# Switch monitoring nodes
	# colorizing functions instead
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	userSetup			###
	radarPinging "$@"	###
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
######  ┬─┐┌─┐┌┬┐┌─┐┬─┐╔═╗┬┌┐┌┌─┐┬┌┐┌┌─┐  #################################################
######  ├┬┘├─┤ ││├─┤├┬┘╠═╝│││││ ┬│││││ ┬  #################################################
######  ┴└─┴ ┴─┴┘┴ ┴┴└─╩  ┴┘└┘└─┘┴┘└┘└─┘  #################################################
# grabbing all the UIDs from radar ########################################################
###########################################################################################
function radarPinging(){
	#### PART 1 ############################
	
	# uidList="FLW8V6"			#My VPS
	# uidList="GGANQX"			#Suspended Account
	# uidList="GKCYWP 2LAUFZ"	#TOSViolation Accounts
	# uidList="MGM7SZ"			#TOSViolation Account
	# uidList="LGRRA1"			#Tear-Down Asset
	
		
	#### PART 2 ############################
	### Deciding how to proceed, dependant on if/what argument is presented at launch ###
	# switching to `case` would probably make more sense..
	#------------------------------------------------------------------------------------
# lets you manually check if a UID should be disabled
	if [ "$1" == "" ]; then
		## input them one at a time to "manually" check and disable monitoring
		while :; do
			sleep 0.1
			read -n6 -p "Check and Disable Monitoring (Radar & Nagios/Prom) for UID: " uid
				# printf "\nDisable Monitoring (Radar & Nagios/Prom) for UID: "
				# read -n6 uid
			echo
			meatGrinder $uid
		done
		
# scans radar for accounts that should be suspended
	elif [ "$1" == "a" ] || [ "$1" == "all" ]; then
		### Building the uidList based on those active in radar ###
		## grabs the radar page, filtering out just the UIDs (probably fails under certain conditions)
		echo "Gathering UID list from Mr. Radar"
		uidList="$(curl -s https://monitor.liquidweb.com/unresponsive.php | grep -Po "(?<=>)[[:digit:]A-Z]{6}" | tac)"
		## runs meatGrinder for all UIDs in the uidList from radar (if it exists)
		if [ "$uidList" != "" ]; then
			for uid in $uidList; do 
				meatGrinder $uid
			done
		fi
		
# disables monitoring in nagios/radar without checking anything
	elif [ $1 == "disable" ]; then
		while :;do
			sleep 0.1
			printf "\nDisabling Monitoring (Radar & Nagios/Prom) \033[31mWITHOUT\033[0m checking status. Be Certain.\nUID: "
			read -n6 uid
			printf "\n"
			bombingRaid $uid
		done
		
# disables monitoring for S services we dont monitor
	elif [ $1 == "s" ]; then
		while :;do
			sleep 0.1
			printf "\nDisabling S Services we don\'t monitor.\nUID: "
			read -n6 uid
			printf "\n"
			payloadSservices $uid
		done

# switch to (and enable) prom, then disable nagios
elif [ $1 == "t" ] || [ $1 == "toggle" ]; then
		# while :;do
			sleep 0.1
			printf "\nConvert to Prom and disable Nagios.\nUID: "
			read -n6 uid
			printf "\n"
			payloadPromToggle $uid
		# done
	fi
}


###########################################################################################
######  ┌┬┐┌─┐┌─┐┌┬┐╔═╗┬─┐┬┌┐┌┌┬┐┌─┐┬─┐  ##################################################
######  │││├┤ ├─┤ │ ║ ╦├┬┘││││ ││├┤ ├┬┘  ##################################################
######  ┴ ┴└─┘┴ ┴ ┴ ╚═╝┴└─┴┘└┘─┴┘└─┘┴└─  ##################################################
# checks account status & disables monitoring #############################################
###########################################################################################
function meatGrinder(){
# Need to break this into a more easily customizable format #
#############################################################
	### Turning the UID into an Account Number ###			
		#saving the Account Number
		uidToAccnt=$(curlCMD https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details uniq_id $1 .accnt)
	### Checking if Account Number is Suspended ###
		#saving the suspension check results
		chkSuspend=$(curlCMD https://api.int.liquidweb.com/bleed/Billing/Account/details accnt $uidToAccnt .account_status)
	### Checking if Asset is in Tear-Down ###
		if [ "$chkSuspend" != "suspended" ]; then
			curlCMD https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details uniq_id $1 .activeStatus,.status 
			#saving the Tear-Down check results
			chkTeardown="$( (echo "$cmdOutput"|grep -m1 Termination)||echo active)"
		### Checking if Account Number is TOSViolation ###
			if ! grep ermination <<< $chkTeardown ; then
				curlCMD https://api.int.liquidweb.com/bleed/Billing/Account/traits accnt $uidToAccnt .traits 
				#saving the TOSViolation check results
				chkTOSViol="$( (echo $cmdOutput|grep -o TOSViolation)||echo active)"
			fi
		fi


	### Disabling Monitoring, if needed ###
	## Colorizing Suspended/TOSViolation/Tear-Down Accounts/Assets ##
		if [ "$chkSuspend" == "suspended" ]; then
			printf "\n\n   UID: $1\nStatus: \033[32m$chkSuspend\033[0m\n"
			## Disabling Nagios Monitoring
			payloadNagios $uid
			## Disabling Radar Monitoring
			payloadRadar $uid
		elif [ "$chkTOSViol" == "TOSViolation" ]; then
			printf "\n\n   UID: $1\nStatus: \033[32m$chkTOSViol\033[0m\n"
			## Disabling Nagios Monitoring
			payloadNagios $uid
			## Disabling Radar Monitoring
			payloadRadar $uid
		elif grep Termination <<< $chkTeardown >/dev/null; then
			printf "\n\n   UID: $1\nStatus: \033[32m$chkTeardown\033[0m\n"
			## Disabling Nagios Monitoring
			payloadNagios $uid
			## Disabling Radar Monitoring
			payloadRadar $uid
		else
			printf "Clean UID: $1\n"
		fi
}

###########################################################################################
######  ┌─┐┬ ┬┬─┐┬  ╔═╗╔╦╗╔╦╗  ############################################################
######  │  │ │├┬┘│  ║  ║║║ ║║  ############################################################
######  └─┘└─┘┴└─┴─┘╚═╝╩ ╩═╩╝  ############################################################
# Making it easier to deal with the curl command ##########################################
###########################################################################################
function curlCMD(){
	# turning the arguments passed into the function into something more readable
		apiURL="$1"
		apiParam="$2"
		apiValue="$3"
		api_jqSearch="$4"
		
	### Building the actual command to hit the API ###
		cmdBase="$(cat <<- EOF
			curl --silent -u $userName:$password
			EOF
			)"
		cmdURL="$(cat <<- EOF
			$apiURL
			EOF
			)"
		cmdData="$(cat <<- EOF
			--data {"params":{"$apiParam":"$apiValue"}}
			EOF
			)"
		cmdParse="$(cat <<- EOF
			jq -r $api_jqSearch
			EOF
			)"
	
	### storing the output ###	
	if [ "$4" == "" ];then
		cmdOutput="$($cmdBase $cmdURL $cmdData)"
	else
		cmdOutput="$($cmdBase $cmdURL $cmdData | $cmdParse)"
	fi
	
}


###########################################################################################
######  ┌┬┐┬┌┬┐┌─┐┌─┐┬ ┬┌┬┐  ##############################################################
######   │ ││││├┤ │ ││ │ │   ##############################################################
######   ┴ ┴┴ ┴└─┘└─┘└─┘ ┴   ##############################################################
# Temporary disable monitoring for a list, or individual UID ##############################
###########################################################################################
function timeout(){
	# Defintes delinquent UIDs and their timeout
	#checks the log for any delinquent UIDs
	# badKids="/var/log/monitoringTimeout.list"
	:
}


###########################################################################################
######  ┬  ┌─┐┬ ┬┌┐┌┌─┐┬ ┬╔╗ ┌─┐┬ ┬  ######################################################
######  │  ├─┤│ │││││  ├─┤╠╩╗├─┤└┬┘  ######################################################
######  ┴─┘┴ ┴└─┘┘└┘└─┘┴ ┴╚═╝┴ ┴ ┴   ######################################################
# Disabling Radar/Nagios/Prom for Select UID ##############################################
###########################################################################################
#### Bombing Raid ###############
# checks nothing, just disables #
function bombingRaid(){			#
	payloadRadar 	$1			#
	payloadNagios 	$1			#
}								#
#################################
	#+++++++++++++++++++++++++++++++++
	### Disabling Radar Monitoring ###
	#+++++++++++++++++++++++++++++++++
	function payloadRadar(){
		curlCMD https://api.int.liquidweb.com/bleed/Monitoring/Sonar/disable uniq_id $1
		printf "\t[\033[31mDisabled\033[0m] Radar  Monitoring\n"
	}	
	#+++++++++++++++++++++++++++++++++++++++
	### Disabling Prom/Nagios Monitoring ###
	#+++++++++++++++++++++++++++++++++++++++
	function payloadNagios(){
		## Switching back and forth appears to be necessary ##
		######################################################
		#disables monitoring for whichever monitoring system is in use (though both use nagios link)
			curlCMD https://api.int.liquidweb.com/bleed/Monitoring/Nagios/disable uniq_id $1
		
		#switches monitoring systems
			curlCMD https://api.int.liquidweb.com/bleed/Asset/Monitoring/convert uniq_id $1
			
		#disables monitoring for whichever monitoring system is in use (though both use nagios link)
			curlCMD https://api.int.liquidweb.com/bleed/Monitoring/Nagios/disable uniq_id $1
		
		printf "\t[\033[31mDisabled\033[0m] Nagios Monitoring\n"
	}
	#+++++++++++++++++++++++++++++++++++++++++
	### Disables Monitoring for S Services ###
	#+++++++++++++++++++++++++++++++++++++++++
	function payloadSservices(){
		printf "\t[Disabling] \033[34mS\033[0m services\n"
		curl --silent \
			-u ${userName}:${password} \
			-H "Content-Type: application/json" \
			-H "Accept: application/json" \
			-X POST \
			--data "{\"params\":{\"subaccnt\":\"$1\",\"enabled\":1,\"services\":[
			{\"name\":\"cpanels\",\"enabled\":0},
			{\"name\":\"ftps\",\"enabled\":0},
			{\"name\":\"https\",\"enabled\":0},
			{\"name\":\"imaps\",\"enabled\":0},
			{\"name\":\"pop3s\",\"enabled\":0}
			]}}" \
			https://api.int.liquidweb.com/bleed/Asset/Monitoring/assert >/dev/null
	}
	#++++++++++++++++++++++++++++++++++++++++++++
	### Enable Prom, Disable Nagios, & Toggle ###
	#++++++++++++++++++++++++++++++++++++++++++++
	function payloadPromToggle(){
		printf "\t[Convert] Nagios to \033[34mProm\033[0m\n"
		#checking what is currently being used
		curlCMD https://api.int.liquidweb.com/bleed/Asset/Monitoring/details subaccnt $uid
		# echo $cmdOutput
		targetStatus=$(  jq -r '.enabled'			<<< $cmdOutput)
		targetMonNode=$( jq -r '.server_pair'		<<< $cmdOutput)
		targetLocation=$(jq -r '.labels .Location'	<<< $cmdOutput)
		targetOutput="$( jq .						<<< $cmdOutput)"
		printf "  Status: $targetStatus\n"
		printf "Mon Type: $targetMonNode\n"
		printf "Location: $targetLocation\n"
		# printf "\n---\nComplete Output:\n$targetOutput"
		
		## checking type and deciding what to do next
		if grep null <<< $targetMonNode ;then
			#(if targetMonNode returns "null", its most likely on nagios)
			printf "\n\n$uid is on \033[31mNagios\033[0m\n\n"
			#+convert to prom
			#+check prom is enabled
		elif [[ "$targetStatus" == "true" ]] ;then
			#(if it returns a prom server pair AND is "enabled" is should be ready)
			printf "\n\n$uid is on \033[34mProm\033[0m and is enabled\n\n"
			#+check is building and prom nodes match, if not. scream
			#+convert to nagios
			#+convert back to prom
			#+confirm monitoring is set to prom and is enabled
		fi
	}
	


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main "$@"
