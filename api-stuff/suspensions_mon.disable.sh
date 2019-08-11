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
	### MISC
	# Expand into a full suite of monitoring tools?
	# Set Monitoring to: Un-Managed / Managed / Fully-Managed
	# Enable/Disable monitoring for speciifc serivces
	# Switch monitoring nodes
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
	
		
	#### PART 2(a) ############################
	### Deciding how to proceed, dependant on if/what argument is presented at launch ###
	# switching to `case` would probably make more sense
	#------------------------------------------------------------------------------------
	
	if [ "$1" == "" ]; then
		## input them one at a time to "manually" check and disable monitoring
		while :; do
			sleep 0.2
			read -n6 -p "Check and Disable Monitoring (Radar & Nagios/Prom) for UID: " uid
				# printf "\nDisable Monitoring (Radar & Nagios/Prom) for UID: "
				# read -n6 uid
			echo
			meatGrinder $uid
		done
		
	elif [ "$1" == "a" ]; then
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
		
	elif [ $1 == "disable" ]; then
		while :;do
			sleep 0.2
			printf "\nDisabling Monitoring (Radar & Nagios/Prom) \033[31mWITHOUT\033[0m checking status. Be Certain.\nUID: "
			read -n6 uid
			printf "\n"
			bombingRaid $uid
		done

	fi

	#### PART 2(b) ############################
	
	
	## lets you just input them one at a time to quickly manually check
	# while :; do
	# 	sleep 0.5
	# 	read -s -n6 -p "UID: " uid
	# 		echo $uid
	# 			### Turning the UID in an Account Number ###			
	# 				curlCMD	https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details uniq_id $uid .accnt
	# 			### Checking is Account Number is Suspended ###
	# 				curlCMD https://api.int.liquidweb.com/bleed/Billing/Account/details accnt $cmdOutput .account_status
	# 			### Printing result ###
	# 				printf "\nUID: $uid\nStatus: \033[32m$cmdOutput\033[0m\n"
	# done
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
	### Turning the UID in an Account Number ###			
		curlCMD	https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details uniq_id $1 .accnt
		#saving the Account Number
		uidToAccnt=$cmdOutput
	### Checking if Account Number is Suspended ###
		curlCMD https://api.int.liquidweb.com/bleed/Billing/Account/details accnt $uidToAccnt .account_status
		#saving the suspension check results
		chkSuspend=$cmdOutput
	### Checking if Account Number is TOSViolation ###
		curlCMD https://api.int.liquidweb.com/bleed/Billing/Account/traits accnt $uidToAccnt .traits
		#saving the TOSViolation check results
		chkTOSViol="$((echo $cmdOutput|grep -o TOSViolation)||echo active)"
	### Checking if Asset is in Tear-Down ###
		curlCMD https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details uniq_id $1 .activeStatus,.status
		#saving the Tear-Down check results
		chkTeardown="$((echo "$cmdOutput"|grep -m1 Termination)||echo active)"

#??? testing ???#
echo " UID to Account: $uidToAccnt"
echo "Suspended Check: $chkSuspend"
echo "      TOS Check: $chkTOSViol"
echo " Teardown Check: $chkTeardown"



	### Colorizing Suspended/TOSViolation/Tear-Down Accounts/Assets ###
		# if [ "$chkSuspend" == "suspended" ]; then
		# 	printf "\n\n   UID: $1\nStatus: \033[32m$chkSuspend\033[0m\n"
		# 	## Disabling Nagios Monitoring
		# 	payloadNagios $uid
		# 	## Disabling Radar Monitoring
		# 	payloadRadar $uid
		# elif [ "$chkTOSViol" == "TOSViolation" ]; then
		# 	printf "\n\n   UID: $1\nStatus: \033[32m$chkTOSViol\033[0m\n"
		# 	## Disabling Nagios Monitoring
		# 	payloadNagios $uid
		# 	## Disabling Radar Monitoring
		# 	payloadRadar $uid
		# elif grep Termination <<< $chkTeardown; then
		# 	printf "\n\n   UID: $1\nStatus: \033[32m$chkTeardown\033[0m\n"
		# 	## Disabling Nagios Monitoring
		# 	payloadNagios $uid
		# 	## Disabling Radar Monitoring
		# 	payloadRadar $uid
		# else
		# 	printf "Clean UID: $1\n"
		# fi
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
			curl -u $userName:$password
			EOF
			)"
		cmdURL="$(cat <<- EOF
			--silent $apiURL
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
	### Disabling Radar Monitoring ###
	function payloadRadar(){
		curlCMD https://api.int.liquidweb.com/bleed/Monitoring/Sonar/disable uniq_id $1
		printf "\t[\033[31mDisabling\033[0m] Radar  Monitoring\n"
	}	

	### Disabling Prom/Nagios Monitoring ###
	function payloadNagios(){
		## Switching back and forth appears to be necessary ##
		######################################################
		#disables monitoring for whichever monitoring system is in use (though both use nagios link)
			curlCMD https://api.int.liquidweb.com/bleed/Monitoring/Nagios/disable uniq_id $1
		
		#switches monitoring systems
			curlCMD https://api.int.liquidweb.com/bleed/Asset/Monitoring/convert uniq_id $1
			
		#disables monitoring for whichever monitoring system is in use (though both use nagios link)
			curlCMD https://api.int.liquidweb.com/bleed/Monitoring/Nagios/disable uniq_id $1
		
		
		printf "\t[\033[31mDisabling\033[0m] Nagios Monitoring\n"
	}
	
	
	
	
	
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main "$@"
