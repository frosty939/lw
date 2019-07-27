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
	## https://wiki.int.liquidweb.com/articles/Guardian_Client_Setup#Automated_Agent_Installation
	######
	## ACTUALLY automates the cdp-agent install
	## (starting with just hte interface stuff)
	## (eventually the entire process, maybe)
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# check for plugins
	# check for available BMs
	# Change the sub-account in billing to a new BM
	# trigger the gbutils thing to finish the rest of the setup
	# confirm cdp-agent can communicate with 
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
###### RUN function #######
###########################
function main(){		###
	configureAgent		###
	function2			###
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
######  ┌─┐┌─┐┌┐┌┌─┐┬┌─┐┬ ┬┬─┐┌─┐╔═╗┌─┐┌─┐┌┐┌┌┬┐  #########################################
######  │  │ ││││├┤ ││ ┬│ │├┬┘├┤ ╠═╣│ ┬├┤ │││ │   #########################################
######  └─┘└─┘┘└┘└  ┴└─┘└─┘┴└─└─┘╩ ╩└─┘└─┘┘└┘ ┴   #########################################
# Sets up everything for the "automated" agent installer script ###########################
# Required for cdp5 -> cdp6 moves                               ###########################
###########################################################################################
function configureAgent(){
	#### PART 1 ############################
	# wget -O ~/guardian_agent_setup.sh  https://files.liquidweb.com/guardian/guardian_agent_setup.sh
	defIP="$(ifconfig | grep -A1 eth1 | awk '/inet/{print $2}'| egrep "10\.[1-4][0-5]\.")"
	## making sure eth1 exists and has a proper IP before reading in more info
	# if [ "$defIP" == "" ];then
	# 	printf "\n\033[33mMake sure that eth1 exists and has the correct IP.\033[0m\n"
	# 	exit 10
	# fi

	## Reading in info
	printf "%34s" "Guardian Asset IP [$defIP]: ";
	read guardian_ip;
	# read -p "Guardian Asset IP [$defIP]: " guardian_ip;
	read -p " Guardian Asset Interface [eth1]: " guardian_interface;
	read -p "    Target Backup Manager [#-##]: " backup_manager;
	## setting default values if nothing is entered
	guardian_ip="${guardian_ip:-$defIP}";
	guardian_interface="${guardian_interface:-eth1}";

	
	gap="$(printf "%68s"|tr " " "=";)";
	# /bin/bash ~/guardian_agent_setup.sh -a ${guardian_ip} -i ${guardian_interface} -m ${backup_manager}
	printf "${gap}\n'Automated' Agent Installation completed with the following settings\n${gap}\n";
	echo "[       Guardian Asset IP ] $guardian_ip";
	echo "[Guardian Asset Interface ] $guardian_interface";
	echo "[   Target Backup Manager ] $backup_manager";
	}
###########################################################################################
######  ╔═╗┬ ┬┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌  ╔╦╗┬ ┬┌─┐  ################################################
######  ╠╣ │ │││││   │ ││ ││││   ║ ││││ │  ################################################
######  ╚  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘   ╩ └┴┘└─┘  ################################################
# FUNCTION2 description ###################################################################
###########################################################################################
function function2(){
	:
	#### PART 1 ############################
	
	}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ FIGHT!! +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main
