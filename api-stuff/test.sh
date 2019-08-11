#!/bin/bash
###### RUN function #######
###########################
function main(){		###
	testing				###
						###
}						###
###########################
function testing(){
	userName="$(cat $HOME/.passwords/billing.userName)"
	password="$(cat $HOME/.passwords/billing)"
	#uidGrab="FLW8V6"		# My Server
	#accntGrab="309431"		# My Account
	#---------------------------------------------------------------------------------
	### TEMP TEST ####
		curlCMD https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details uniq_id FLW8V6
	##################################################################################
	### Asset info (ssh port, pw, etc) Check ###
	#curl -u ${userName}:${password} \
	#	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/Auth/details' \
	#	--data '{"params":{"uniq_id":"FLW8V6"}}'
	##################################################################################
	### Account Highlights ###
	# curl -u ${userName}:${password} \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Account/highlights' \
	# 	--data '{"params":{"accnt":"309431"}}'
	### Account Details ###
	# curl -u ${userName}:${password} \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Account/details' \
	# 	--data '{"params":{"accnt":"309431"}}'
	### Account Traits ###
	# curl -u ${userName}:${password} \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Account/traits' \
	# 	--data '{"params":{"accnt":"271771"}}'
	##################################################################################
	### Account Details ###
	# curl -u ${userName}:${password} \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Account/traits' \
	# 	--data '{"params":{"accnt":"309431"}}'
	##################################################################################
}
  


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
		$cmdBase $cmdURL $cmdData
	else
		$cmdBase $cmdURL $cmdData | $cmdParse
	fi
}


#curl -u ${userName}:${password} \
##	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details' \
#	--silent 'https://api.int.liquidweb.com/bleed/Asset/Monitoring/status' \
##	 --data '{"params":{"uniq_id":"FLW8V6"}}' | jq -r '.accnt' \
#	 --data '{"params":{"accnt":"309431"}}' | jq -r '.accnt'

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main "$@"
