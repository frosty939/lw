#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
# Created by:	Wayne Boyer
#=======================================================================================
	## Swap use investigation + garbage collection + formatted format_codeBlocks
	## 
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# colorize if others are active
	# colorize other stuff
	# log?
	# clean up output
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P0: FULL ONE-LINER
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function titleMain(){ printf "###H \033[1;36m${*}\033[0m"; };function titleSec (){ printf "[\033[34m${*}\033[0m]"; };format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";initialLogin=$(printf %b "\n${format_noteBlock}\n\n\n> Reported with: Swap Use\n> Wiki Used: http://sites-wiki.int.liquidweb.com/display/csops/CriticalSwap\n\n$(titleMain Initial Server Stats)\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n$(titleSec Active Sessions)\n$(w)\n\n$(titleSec Swap Use)\n$(df -h|grep -v docker )\n\n$(titleSec RAM Use)\n$(free -h||free -m)\n${format_codeBlock}\n\n");/etc/init.d/php5.6-fpm reload;/etc/init.d/php7.0-fpm reload;/etc/init.d/php7.1-fpm reload;/etc/init.d/php7.2-fpm reload;if ! egrep "^[[:space:]]*/dev/vda2 none swap sw 0 0" /etc/fstab >/dev/null;then echo "/dev/vda2 none swap sw 0 0" >> /etc/fstab;fi;swapon -a;printf %b "${initialLogin}";printf %b "\n\n$(titleMain Action\(s\) Taken)\n** Reloaded php-fpm Processes\n**| ${format_codeBlock}\n$(printf %s '/etc/init.d/php5.6-fpm reload;/etc/init.d/php7.0-fpm reload;/etc/init.d/php7.1-fpm reload;/etc/init.d/php7.2-fpm reload')\n${format_codeBlock}\n** Checked/Added Swap Settings to \`/etc/fstab\` and enabling all swap devices\n**| ${format_codeBlock}\nWIP\n${format_codeBlock}\n\n$(titleMain Ending RAM/Swap Use)\n**| ${format_codeBlock}\n$(free -h 2>/dev/null|| free -m)\n${format_codeBlock}\n\n\n\n${format_noteBlock}";


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P1: Individual Sections
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### Intial Login (from disk.use.sh) ###
function titleMain(){ printf "###H \033[1;36m${*}\033[0m"; };function titleSec (){ printf "[\033[34m${*}\033[0m]"; };format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";initialLogin=$(printf %b "\n${format_noteBlock}\n\n\n> Reported with: Swap Use\n> Wiki Used: http://sites-wiki.int.liquidweb.com/display/csops/CriticalSwap\n\n$(titleMain Initial Server Stats)\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n$(titleSec Active Sessions)\n$(w)\n\n$(titleSec Swap Use)\n$(df -h|grep -v docker )\n\n$(titleSec RAM Use)\n$(free -h||free -m)\n${format_codeBlock}\n\n");


### Reloading php-fpm ###
/etc/init.d/php5.6-fpm reload;/etc/init.d/php7.0-fpm reload;/etc/init.d/php7.1-fpm reload;/etc/init.d/php7.2-fpm reload;


### Adding/Checking /etc/fstab for correct swap config ###
if ! egrep "^[[:space:]]*/dev/vda2 none swap sw 0 0" /etc/fstab >/dev/null; then 
	echo "/dev/vda2 none swap sw 0 0" >> /etc/fstab;
	echo "Enabling all available swap devices";
fi;
swapon -a;
free -h;



### Notes Output ###
printf %b "${initialLogin}";
printf %b "\n\n
	$(titleMain Action\(s\) Taken)\n
		** Reloaded php-fpm Processes\n
			**| ${format_codeBlock}\n
				$(printf %s '/etc/init.d/php5.6-fpm reload;/etc/init.d/php7.0-fpm reload;/etc/init.d/php7.1-fpm reload;/etc/init.d/php7.2-fpm reload')\n
			${format_codeBlock}\n
		** Checked/Added Swap Settings to \`/etc/fstab\` and enabling all swap devices\n
			**| ${format_codeBlock}\n
				$(printf %s 'if ! egrep "^[[:space:]]*/dev/vda2 none swap sw 0 0" /etc/fstab >/dev/null; then echo "/dev/vda2 none swap sw 0 0" >> /etc/fstab;echo "Enabling all available swap devices";fi;swapon -a')\n
			${format_codeBlock}\n\n
	$(titleMain Ending RAM/Swap Use)\n
		**| ${format_codeBlock}\n
			$(free -h 2>/dev/null|| free -m)\n
		${format_codeBlock}\n\n";

### Notes Output One-Liner ###
printf %b "${initialLogin}";printf %b "\n\n	$(titleMain Action\(s\) Taken)\n	** Reloaded php-fpm Processes\n	**| ${format_codeBlock}\n	$(printf %s '/etc/init.d/php5.6-fpm reload;/etc/init.d/php7.0-fpm reload;/etc/init.d/php7.1-fpm reload;/etc/init.d/php7.2-fpm reload')\n	${format_codeBlock}\n	** Checked/Added Swap Settings to \`/etc/fstab\` and enabling all swap devices\n	**| ${format_codeBlock}\n	$(printf %s 'if ! egrep "^[[:space:]]*/dev/vda2 none swap sw 0 0" /etc/fstab >/dev/null; then echo "/dev/vda2 none swap sw 0 0" >> /etc/fstab;echo "Enabling all available swap devices";fi;swapon -a')\n	${format_codeBlock}\n\n	$(titleMain Ending RAM/Swap Use)\n	**| ${format_codeBlock}\n	$(free -h 2>/dev/null|| free -m)\n	${format_codeBlock}\n\n";
