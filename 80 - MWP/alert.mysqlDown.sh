#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
# Created by:	Wayne Boyer
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
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P0: FULL ONE-LINER
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function titleMain(){ printf "###H \033[1;36m${*}\033[0m"; };function titleSec (){ printf "[\033[34m${*}\033[0m]"; };format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";initialLogin=$(printf %b "\n${format_noteBlock}\n\n\n> Reported with: MySQL Down\n> Wiki Used:  http://sites-wiki.int.liquidweb.com/display/csops/MysqlDown\n\n$(titleMain Initial Server Stats)\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n$(titleSec Active Sessions)\n$(w)\n\n$(titleSec MySQL Down)\n$(df -h|grep -v docker )\n\n$(titleSec RAM Use)\n$(free -h||free -m)\n\n$(titleSec MySQL Status)\n$(service mysql status | head -5)\n\n$(mysqladmin pr)\n${format_codeBlock}\n\n");if ! grep -F "active (running)" <<< "$initialLogin"; then service mysql stop;service mysql start;fi;if ! egrep "^[[:space:]]*/dev/vda2 none swap sw 0 0" /etc/fstab; then echo "/dev/vda2 none swap sw 0 0" >> /etc/fstab;echo "Enabling all available swap devices";fi;swapon -a;free -h;printf %b "${initialLogin}";printf %b "\n\n$(titleMain Action\(s\) Taken)\n** MySQL full \`start\`/\`stop\`'d\n**| ${format_codeBlock}\n$(printf %s 'service mysql stop;service mysql start')\n${format_codeBlock}\n** Checked/Enabled Swap\n**| ${format_codeBlock}\nWIP\n${format_codeBlock}\n\n";printf %b "$(titleMain Misc.)\n** Most Recent oom-killed Processes\n**| ${format_codeBlock}\n$((grep 'invoked oom-killer' /var/log/syslog | tail -5) 2>/dev/null)\n${format_codeBlock}\n\n";printf %b "\n$(titleMain Ending MySQL/Server Stats)\n**| ${format_codeBlock}\n$(titleSec RAM Use)\n$(free -h||free -m)\n\n$(titleSec MySQL Status)\n$(service mysql status | head -5)\n\n${format_codeBlock}\n\n\n${format_noteBlock}";

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P1: READABLE
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### header functions ###
	function titleMain(){ printf "###H \033[1;36m${*}\033[0m"; };
	function titleSec (){ printf "[\033[34m${*}\033[0m]"; };
# Visual start/stop for entire notes section
	format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";
# Code block
	format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";

#### Saving "initial login" info ############################
initialLogin=$(printf %b "\n${format_noteBlock}
	\n\n\n> Reported with: MySQL Down\n
	> Wiki Used:  http://sites-wiki.int.liquidweb.com/display/csops/MysqlDown\n\n
	$(titleMain Initial Server Stats)\n
	**| ${format_codeBlock}\n
	===== $(hostname) =====\n\n
	$(titleSec Active Sessions)\n
	$(w)\n\n
	$(titleSec MySQL Down)\n
	$(df -h|grep -v docker )\n\n
	$(titleSec RAM Use)\n$(free -h||free -m)\n\n
	$(titleSec MySQL Status)\n
	$(service mysql status | head -5)\n\n
	$(mysqladmin pr)\n
	${format_codeBlock}\n\n");

	
### Actions ####
# checking if mysql is running, then restarting it
if ! grep -F "active (running)" <<< "$initialLogin"; then
	service mysql stop;
	service mysql start;
fi;

# checking/enabling swap use 
if ! egrep "^[[:space:]]*/dev/vda2 none swap sw 0 0" /etc/fstab; then echo "/dev/vda2 none swap sw 0 0" >> /etc/fstab;echo "Enabling all available swap devices";fi;swapon -a;free -h



### Actions Taken ###
printf %b "${initialLogin}";
printf %b "\n\n
	$(titleMain Action\(s\) Taken)\n
	** MySQL full \`start\`/\`stop\`'d\n
	**| ${format_codeBlock}\n
	$(printf %s 'service mysql stop;service mysql start')\n
	${format_codeBlock}\n
	** Checked/Enabled Swap File\n
	**| ${format_codeBlock}\n
	
	
	### WIP
	$(printf %s 'if ! egrep "^[[:space:]]*/dev/vda2 none swap sw 0 0" /etc/fstab; then echo "/dev/vda2 none swap sw 0 0" >> /etc/fstab;echo "Enabling all available swap devices";fi;swapon -a;free -h')\n
	### WIP
	
	
	${format_codeBlock}\n\n";
	
### Did it get oom-killed? ###
printf %b "$(titleMain Misc.)\n
	** Most Recent oom-killed Processes\n
	**| ${format_codeBlock}\n
	$((grep 'invoked oom-killer' /var/log/syslog | tail -5) 2>/dev/null)\n
	${format_codeBlock}\n\n";

### Ending Server/MySQL Stats ###
printf %b "\n
	$(titleMain Ending MySQL/Server Stats)\n
	**| ${format_codeBlock}\n
	$(titleSec RAM Use)\n$(free -h||free -m)\n\n
	$(titleSec MySQL Status)\n
	$(service mysql status | head -5)\n\n
	${format_codeBlock}\n\n\n
	${format_noteBlock}";



#+++++++++++++++++++++
# One-Liner
#+++++++++++++++++++++
function titleMain(){ printf "###H \033[1;36m${*}\033[0m"; };function titleSec (){ printf "[\033[34m${*}\033[0m]"; };format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";initialLogin=$(printf %b "\n${format_noteBlock}\n\n\n> Reported with: MySQL Down\n> Wiki Used:  http://sites-wiki.int.liquidweb.com/display/csops/MysqlDown\n\n$(titleMain Initial Server Stats)\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n$(titleSec Active Sessions)\n$(w)\n\n$(titleSec MySQL Down)\n$(df -h|grep -v docker )\n\n$(titleSec RAM Use)\n$(free -h||free -m)\n\n$(titleSec MySQL Status)\n$(service mysql status | head -5)\n\n$(mysqladmin pr)\n${format_codeBlock}\n\n");if ! grep -F "active (running)" <<< "$initialLogin"; then service mysql stop;service mysql start;fi;if ! egrep "^[[:space:]]*/dev/vda2 none swap sw 0 0" /etc/fstab; then echo "/dev/vda2 none swap sw 0 0" >> /etc/fstab;echo "Enabling all available swap devices";fi;swapon -a;free -h;printf %b "${initialLogin}";printf %b "\n\n$(titleMain Action\(s\) Taken)\n** MySQL full \`start\`/\`stop\`'d\n**| ${format_codeBlock}\n$(printf %s 'service mysql stop;service mysql start')\n${format_codeBlock}\n** Checked/Enabled Swap\n**| ${format_codeBlock}\nWIP\n${format_codeBlock}\n\n";printf %b "$(titleMain Misc.)\n** Most Recent oom-killed Processes\n**| ${format_codeBlock}\n$((grep 'invoked oom-killer' /var/log/syslog | tail -5) 2>/dev/null)\n${format_codeBlock}\n\n";printf %b "\n$(titleMain Ending MySQL/Server Stats)\n**| ${format_codeBlock}\n$(titleSec RAM Use)\n$(free -h||free -m)\n\n$(titleSec MySQL Status)\n$(service mysql status | head -5)\n\n${format_codeBlock}\n\n\n${format_noteBlock}";
