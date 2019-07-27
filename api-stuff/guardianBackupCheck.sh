#!/bin/bash
#doom
#                 _       _
#                (_)     | |
#   ___  ___ _ __ _ _ __ | |_
#  / __|/ __| '__| | '_ \| __|
#  \__ \ (__| |  | | |_) | |_
#  |___/\___|_|  |_| .__/ \__|
#                  | |
#                  |_|
#ANSI shadow
#  ███╗   ██╗ █████╗ ███╗   ███╗███████╗
#  ████╗  ██║██╔══██╗████╗ ████║██╔════╝
#  ██╔██╗ ██║███████║██╔████╔██║█████╗
#  ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝
#  ██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗
#  ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## 
	##
	## 
	## 
#=======================================================================================
#=======================================================================================
	## https://ask.metafilter.com/18923/How-do-you-handle-authentication-via-cookie-with-CURL
	##	## curl -d "username=miniape&password=SeCrEt" http://whatever.com/login
	## and if you want to store the cookie that comes back you do so by specifying a cookie file:
	## 	## curl -c cookies.txt -d "username=miniape&password=SeCrEt" http://whatever.com/login
	## 
	## and to use those cookie in later requests you do:
	## curl -b cookies.txt -d "username=miniape&password=SeCrEt" http://whatever.com/login
	## or do both if you want to both send and receive cookies:
	## 	## curl -b cookies.txt -c cookies.txt -d "username=miniape&password=SeCrEt" http://whatever.com/login
	## 
	## once you have the cookie
	##	## curl -b cookies.txt http://whatever.com/content
	#
	#*************** NEED TO DO/ADD ***********************
	# 
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	# cookieMonster		###
	gatherAlertInfo		###
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
### EXAMPLE ###
#  curl -u USER:PASS --silent 'API URL' --data '{"params":{"PARAM":"VALUE"}}'
## API URL	= https://billing.int.liquidweb.com/mysql/content/admin/api/internal/docs/bleed/Billing/Account.html#method_statuses
#￼# PARAM	 = parameter from the api
## VALUE 	= Account Number (sometimes)
#
#
#
###########################################################################################
######  ╔═╗┌─┐┌─┐┬┌─┬┌─┐╔╦╗┌─┐┌┐┌┌─┐┌┬┐┌─┐┬─┐  ############################################
######  ║  │ ││ │├┴┐│├┤ ║║║│ ││││└─┐ │ ├┤ ├┬┘  ############################################
######  ╚═╝└─┘└─┘┴ ┴┴└─┘╩ ╩└─┘┘└┘└─┘ ┴ └─┘┴└─  ############################################
# FUNCTION1 description ###################################################################
###########################################################################################
function cookieMonster(){
	userName=
	password=
	
	userAgent='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/53maildb.hmp1.com7.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36'
	#### Site Probing ############################
	curl -H "${userAgent}" thesus.work
	}
###########################################################################################
######  ┌─┐┌─┐┌┬┐┬ ┬┌─┐┬─┐╔═╗┬  ┌─┐┬─┐┌┬┐╦┌┐┌┌─┐┌─┐  ######################################
######  │ ┬├─┤ │ ├─┤├┤ ├┬┘╠═╣│  ├┤ ├┬┘ │ ║│││├┤ │ │  ######################################
######  └─┘┴ ┴ ┴ ┴ ┴└─┘┴└─╩ ╩┴─┘└─┘┴└─ ┴ ╩┘└┘└  └─┘  ######################################
# Getting basic info about guardian alert from UID ########################################
###########################################################################################
function gatherAlertInfo(){
	############################
	#### original from dnemcik
	##echo "What UUID?"; read UUID; curl -Gs 'http://10.30.9.222:9090/api/v1/query' --data-urlencode "query=ALERTS" | jq --arg UUID "$UUID" '.data.result[] | {uniq_id: .metric.uniq_id, instance: .metric.instance, policy_description: .metric.policy_description, disksafe_description: .metric.disksafe_description, alertname: .metric.alertname, alertstate: .metric.alertstate} | select(.uniq_id == $UUID)'
	############################
	while :;do
		sleep 1;
		read -n6 -p "UUID: " UUID;
		curl -Gs 'http://10.30.9.222:9090/api/v1/query' --data-urlencode "query=ALERTS" \
			| jq --arg UUID "$UUID" '.data.result[] | {uniq_id: .metric.uniq_id, instance: .metric.instance, policy_description: .metric.policy_description, disksafe_description: .metric.disksafe_description, alertname: .metric.alertname, alertstate: .metric.alertstate} | select(.uniq_id == $UUID)' \
				| sed 's/["}{,]//g' \
				| awk 'NFS=":"{printf "%25s  %s\n",$1,$2}' \
				| sed -E 's|(.+instance:[[:space:]]+)(.+):9100|\1https:\/\/\2\/Agent|'
		echo
	done
	#### PART 1 ############################
	
	}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main
