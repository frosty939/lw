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
	## Grabs the list of UIDs from radar (or from a file)
	## Turns them into account numbers
	## Checks if account is suspended or not
	#
	# how to hit the API		curl -u USER:PASS --silent 'API URL' --data '{"params":{"accnt":"account_status"}}'
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# check if the password/username files exist, if not, create them
	# clean this garbage up
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
	payload				###
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
	# grabs the radar page, minus the progress bar
	# pulls out just the UIDs
	# uidList="$(curl -s https://monitor.liquidweb.com/unresponsive.php | grep -Po "(?<=>)[[:digit:]A-Z]{6}")"
	
	# uidList="FLW8V6 BNVE2V GGANQX"	#temp UID list so im not spamming radar
	uidList="GGANQX"			#Suspended Account
	# uidList="GKCYWP 2LAUFZ"	#TOSViolation Accounts
	
	#### PART 2 ############################
	function curlCMD(){
		# turning the arguments passed into the function into something more readable
			apiURL="$1"
			apiParam="$2"
			apiValue="$3"
			apiSearch="$4"
			
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
				 jq -r $apiSearch
				EOF
				)"
		### storing the output ###	
		cmdOutput="$($cmdBase $cmdURL $cmdData | $cmdParse)"
					
		# curl -u ${userName}:${password} \
		# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details' \
		# 	$uidToAccnt \
		# 	| jq -r '.activeStatus'
		
	}
	
	
	#### PART 3(a) ############################
	## comparing against the radar list of UIDs if no argument is given to the script
	## this need more work.
	if [ "$1" == "" ]; then
		for uid in $uidList; do 
			# a shitty way to have it accept variables in the 'data' section
			# uidToAccnt="$(cat <<- EOF
			# 				--data {"params":{"uniq_id":"$uid"}}
			# 			EOF
			# 			)"
			# a shitty way to turn a UID into an account number
	
			## (based on account number) getting the account's status
				# using my account
					# curl -u ${userName}:${password} \
					# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Account/details' \
					# 	--data '{"params":{"accnt":"309431"}}'\
					# 	| jq -r '.account_status'
			### Turning the UID in an Account Number ###			
				# uidToAccnt="$(curlCMD https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details uniq_id $uid .accnt )"
				curlCMD	https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details uniq_id $uid .accnt
			### Checking if Account Number is Suspended ###
				# curlCMD https://api.int.liquidweb.com/bleed/Billing/Account/details accnt $uidToAccnt .account_status
				curlCMD https://api.int.liquidweb.com/bleed/Billing/Account/details accnt $cmdOutput .account_status
			### Checking if Account Number is TOSViolation ###
				# curlCMD https://api.int.liquidweb.com/bleed/Billing/Account/traits accnt 
			### Colorizing Suspended Accounts ###
				if [ "$cmdOutput" == "suspended" ]; then
					printf "\n   UID: $uid\nStatus: \033[32m$cmdOutput\033[0m\n"
				else
					printf "\n   UID: $uid\nStatus: $cmdOutput\n"
				fi
			## (based on UID) getting account's status (does not include suspended or not, merely the asset build status)
				# using UIDs from radar
				# curl -u ${userName}:${password} \
				# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details' \
				# 	$uidToAccnt \
				# 	| jq -r '.activeStatus'
	
				# curl -u ${userName}:${password} \
				# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details' \
				# 	$uidToAccnt \
				# 	| jq -r '.activeStatus'
				# printf "\n\n"
			done
	fi

	#### PART 3(b) ############################
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
######  ┌─┐┌─┐┬ ┬┬  ┌─┐┌─┐┌┬┐  ############################################################
######  ├─┘├─┤└┬┘│  │ │├─┤ ││  ############################################################
######  ┴  ┴ ┴ ┴ ┴─┘└─┘┴ ┴─┴┘  ############################################################
# Disabling Radar for Select UIDs #########################################################
###########################################################################################
function payload(){
	:
}	
	
	
	
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main "$@"
