#!/bin/bash
###### RUN function #######
###########################
function main(){		###
	testing	"$@"		###
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
		# curlCMD https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details uniq_id FLW8V6
	##################################################################################
	### View Asset's Monitoring Details ###
	#(which system is it using, which services are checked, etc)
	curl -u ${userName}:${password} \
		-H "Content-Type: application/json" \
		-H "Accept: application/json" \
		--silent 'https://api.int.liquidweb.com/bleed/Asset/Monitoring/details' \
		--data '{"params":{"subaccnt":"FLW8V6"}}'
	
	### View service monitoring status ###
			
	### Disables the S services we don't monitor ###
	# uid="$1"
	# echo $uid
	# curl -u ${userName}:${password} \
	# 	-H "Content-Type: application/json" \
	# 	-H "Accept: application/json" \
	# 	-X POST \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Asset/Monitoring/assert' \
	# 	--data "{\"params\":{\"subaccnt\":\"$uid\",\"enabled\":1,\"services\":[
	# 	{\"name\":\"cpanels\",\"enabled\":0},
	# 	{\"name\":\"ftps\",\"enabled\":0},
	# 	{\"name\":\"https\",\"enabled\":0},
	# 	{\"name\":\"imaps\",\"enabled\":0},
	# 	{\"name\":\"pop3s\",\"enabled\":0}
	# 	]}}" | jq
		
	### Set what is being Monitored ###
	#
	# each="FLW8V6"
	# curl -u ${userName}:${password} \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Asset/Monitoring/assert' \
	# 	--data "{\"params\":{\"subaccnt\": \"$each\",\"enabled\":1,\"services\":[
	# 	        {\"name\":\"cpanel\",\"enabled\":0},
	# 	        {\"name\":\"cpanels\",\"enabled\":0},
	# 	        {\"name\":\"dns\",\"enabled\":0},
	# 	        {\"name\":\"ftp\",\"enabled\":0},
	# 	        {\"name\":\"ftps\",\"enabled\":0},
	# 	        {\"name\":\"http\",\"enabled\":0},
	# 	        {\"name\":\"https\",\"enabled\":0},
	# 	        {\"name\":\"imap\",\"enabled\":0},
	# 	        {\"name\":\"imaps\",\"enabled\":0},
	# 	        {\"name\":\"mssql\",\"enabled\":0},
	# 	        {\"name\":\"mysql\",\"enabled\":0},
	# 	        {\"name\":\"plesk\",\"enabled\":0},
	# 	        {\"name\":\"pop3\",\"enabled\":0},
	# 	        {\"name\":\"pop3s\",\"enabled\":0},
	# 	        {\"name\":\"rdp\",\"enabled\":0},
	# 	        {\"name\":\"smtp\",\"enabled\":0},
	# 	        {\"name\":\"ping\",\"enabled\":1},
	# 	        {\"name\":\"ssh\",\"enabled\":1}
	# 				]}}"

		# --data '{"params":{"subaccnt":"FLW8V6"}}'

	### Domain info (pw, ip, parent, etc) Check ###
	# curl -u ${userName}:${password} \
	# 	-H "Content-Type: application/json" \
	# 	-H "Accept: application/json" \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/list' \
	# 	--data '{"params":{"domain":"default.mwp.zsv58b97-liquidwebsites.com"}}'
	### Asset info (pw, ip, parent, etc) Check ###
	# curl -u ${userName}:${password} \
	# 	-H "Content-Type: application/json" \
	# 	-H "Accept: application/json" \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details' \
	# 	--data '{"params":{"uniq_id":"FLW8V6"}}'
	### Asset info (ssh port) check ###
	# curl -u ${userName}:${password} \
	# 	-H "Content-Type: application/json" \
	# 	-H "Accept: application/json" \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/Auth/details' \
	# 	--data '{"params":{"uniq_id":"514B5M"}}'
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
	# 	--data '{"params":{"accnt":"144541"}}'
	##################################################################################
	### Asset Details ###
	# curl -u ${userName}:${password} \
	# 	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details' \
	# 	--data '{"params":{"uniq_id":"00DRFZ"}}'
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
