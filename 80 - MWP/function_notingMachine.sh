#!/bin/bash
#doom
#               _   _             
#              | | (_)            
#   _ __   ___ | |_ _ _ __   __ _ 
#  | '_ \ / _ \| __| | '_ \ / _` |
#  | | | | (_) | |_| | | | | (_| |
#  |_| |_|\___/ \__|_|_| |_|\__, |
#                            __/ |
#                           |___/ 
#ANSI shadow
#  ███╗   ███╗ █████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗
#  ████╗ ████║██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝
#  ██╔████╔██║███████║██║     ███████║██║██╔██╗ ██║█████╗  
#  ██║╚██╔╝██║██╔══██║██║     ██╔══██║██║██║╚██╗██║██╔══╝  
#  ██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████╗
#  ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝
#                                                          
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## Lets you literally just copy/paste from terminal and have it be formated for SF
	#####
	## Lets you easily convert a list of commands into a markdown formated,
	## note's friendly output.
	## 
#=======================================================================================
#=======================================================================================
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
	greetingsGoblin			###
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
######  ┌─┐┬─┐┌─┐┌─┐┌┬┐┬┌┐┌┌─┐┌─┐╔═╗┌─┐┌┐ ┬  ┬┌┐┌  ########################################
######  │ ┬├┬┘├┤ ├┤  │ │││││ ┬└─┐║ ╦│ │├┴┐│  ││││  ########################################
######  └─┘┴└─└─┘└─┘ ┴ ┴┘└┘└─┘└─┘╚═╝└─┘└─┘┴─┘┴┘└┘  ########################################
# grabs info on the server at initial loging (well.. when ever you run it) ################
# allow for call back of info to smooth out notes #########################################
###########################################################################################
function greetingsGoblin(){
	### header functions ###
		function titleMain(){ printf "###H \033[1;36m${*}\033[0m"; };
		function titleSec (){ printf "[\033[34m${*}\033[0m]"; };
	# Visual start/stop for entire notes section
		format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";
	# Code block
		format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";

	#### Saving "initial login" info ############################
	initialLogin=$(printf %b "\n${format_noteBlock}
		\n\n\n> Reported with: Disk Use\n\n
		$(titleMain Initial Server Stats)\n
		**| ${format_codeBlock}\n
		===== $(hostname) =====\n\n
		$(titleSec Active Sessions)\n
		$(w)\n\n
		$(titleSec Disk Use)\n
		$(df -h|grep -v docker )\n\n
		$(titleSec RAM Use)\n$(free -h||free -m)\n
		${format_codeBlock}\n\n");
		
		echo "$initialLogin"

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
