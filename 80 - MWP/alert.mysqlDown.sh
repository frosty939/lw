#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## Checking on mysql and trying to revive it
	## 
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	#
	#
	#
	#
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


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
	$(titleSec MySQL Status)\n
	$(service mysql status | head -7)\n\n
	$(mysqladmin pr)\n
	${format_codeBlock}\n\n");
	

if grep -F "active (running)" <<< "$initialLogin"; then
	echo "mysql FAILED"
else
	echo "mysql might be fine
