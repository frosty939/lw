#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
# Created by:	Wayne Boyer
#=======================================================================================
	## Disk use investigation + garbage collection + formatted format_codeBlocks
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
	# consolidate repeated stuff
	# optimize the `find`'s, they are taking way too long
	# shadow sections so they are visually more sticky
	# ctrl-c to cancel disk check section(s)
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P0: FULL ONE-LINER
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# function nul(){ "$@" >/dev/null 2>&1; };

## v1.2 ##
function titleMain(){ printf "###H \033[1;36m${*}\033[0m"; };function titleSec (){ printf "[\033[34m${*}\033[0m]"; };format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";initialLogin=$(printf %b "\n${format_noteBlock}\n\n\n> Reported with: Disk Use\n> Wiki Used:   http://sites-wiki.int.liquidweb.com/display/csops/VPS-+Low+Disk+Space+alert\n\n$(titleMain Initial Server Stats)\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n$(titleSec Active Sessions)\n$(w)\n\n$(titleSec Disk Use)\n$(df -h|grep -v docker )\n\n$(titleSec RAM Use)\n$(free -h||free -m)\n${format_codeBlock}\n\n");printf "\nPurging Wraith & Pruning Docker (this may take some time)\n";find /home/wraith -mtime +5 -exec rm {} 2>/dev/null \; ;docker system prune -fa;printf %b "${initialLogin}";printf %b "\n\n$(titleMain Action\(s\) Taken)\n** Wraith Purged\n**| ${format_codeBlock}\n$(printf %s 'find /home/wraith -mtime +5 -exec rm {} \;')\n${format_codeBlock}\n** Docker Pruned\n**| ${format_codeBlock}\n$(printf %s 'docker system prune -fa')\n${format_codeBlock}\n$(titleMain Disk Usage)\n** Logs over 500M\n**| ${format_codeBlock}\n$(find / -not -path /proc -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +500M -exec ls -sh {} \; | awk '{printf "%6s\t%s\n",$1,$2}')\n${format_codeBlock}\n\n** Directories over 1G:\n**| ${format_codeBlock}\n";dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {printf "%6s\t%s\n",$1,$2}' | sort -rn);printf %b "$(for i in $(echo "$dirs" | awk '{print $2}');do if [ "$(echo "$dirs"| egrep $i -c)" == 1 ];then echo "$dirs"| egrep $i;fi;done)\n${format_codeBlock}\n\n";printf %b "$(titleMain Ending Disk Space)\n**| ${format_codeBlock}\n$(df -h | grep -v docker)\n${format_codeBlock}\n\n\n${format_noteBlock}\n\n"


## v1.1 ##
# format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="$(printf %3s | tr " " "\`")";initialLogin=$(printf %b "${format_noteBlock}\n\n\n> Reported with: Disk Use\n\n###H Initial Server Stats\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n[Active Sessions]\n$(w)\n\n[Disk Use]\n$(df -h|grep -v docker )\n\n[RAM Use]\n$(free -h||free -m)\n${format_codeBlock}");printf "\nPurging Wraith & Pruning Docker (this may take some time)\n";find /home/wraith -mtime +5 -exec rm {} 2>/dev/null \; ;docker system prune -fa;printf %s "${initialLogin}";printf %b "\n\n###H Action(s) Taken\n** Wraith Purged\n**| ${format_codeBlock}\n$(printf %s 'find /home/wraith -mtime +5 -exec rm {} \;')\n${format_codeBlock}\n** Docker Pruned\n**| ${format_codeBlock}\n$(printf %s 'docker system prune -fa')\n${format_codeBlock}\n###H Disk Usage\n** Logs over 500M\n**| ${format_codeBlock}\n$(find / -not -path /proc -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +500M -exec ls -sh {} \; | awk '{printf "%6s\t%s\n",$1,$2}')\n${format_codeBlock}\n\n** Directories over 1G:\n**| ${format_codeBlock}\n";dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {printf "%6s\t%s\n",$1,$2}' | sort -rn);printf %b "$(for i in $(echo "$dirs" | awk '{print $2}');do if [ "`echo "$dirs"| egrep $i -c`" == 1 ];then echo "$dirs"| egrep $i;fi;done)\n${format_codeBlock}\n\n";printf %b "###H Ending Disk Space\n**| ${format_codeBlock}\n$(df -h | grep -v docker)\n${format_codeBlock}\n\n\n${format_noteBlock}\n\n"


## v1 ##
# format_codeBlock="$(printf %3s | tr " " "\`")";initialLogin=$(printf %b "\n\n\n> Reported with: Disk Use\n\n###H Checking logged in users\n**| ${format_codeBlock}\n$(w)\n${format_codeBlock}\n\n###H Initial Server Stats\n**| ${format_codeBlock}\n[Disk Use]\n$(df -h|grep -v docker )\n\n[RAM Use]\n$(free -h||free -m)\n${format_codeBlock}\n\n\n");printf "\nPurging Wraith & Pruning Docker (this may take some time)\n";find /home/wraith -mtime +5 -exec rm {} 2>/dev/null \; ;docker system prune -fa;printf %s "${initialLogin}";printf %b "\n\n\n###H Action(s) Taken\n** Wraith Purged\n**| ${format_codeBlock}\n$(printf %s 'find /home/wraith -mtime +5 -exec rm {} \;')\n${format_codeBlock}\n** Docker Pruned\n**| ${format_codeBlock}\n$(printf %s 'docker system prune -fa')\n${format_codeBlock}\n###H Disk Usage\n** Logs over 500M\n**| ${format_codeBlock}\n$(find / -not -path /proc -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +500M -exec ls -sh {} \; | awk '{printf "%6s\t%s\n",$1,$2}')\n${format_codeBlock}\n\n** Directories over 1G:\n**| ${format_codeBlock}\n";dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {print $1"    "$2}' | sort -rn);printf %b "$(for i in $(echo "$dirs" | awk '{print $2}');do if [ "`echo "$dirs"| egrep $i -c`" == 1 ];then echo "$dirs"| egrep $i;fi;done)\n${format_codeBlock}\n\n";printf %b "###H Ending Disk Space\n**| ${format_codeBlock}\n $(df -h | grep -v docker)\n${format_codeBlock}\n"

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P1: Initial Login
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##########################################################################################################
# v1.2
##########################################################################################################
#### Creating Format Variables ############################
### header functions ###
	function titleMain(){ printf "###H \033[1;36m${*}\033[0m"; };
	function titleSec (){ printf "[\033[34m${*}\033[0m]"; };
# Visual start/stop for entire notes section
	format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";
# Code block
	format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";

#### Saving "initial login" info ############################
initialLogin=$(printf %b "\n${format_noteBlock}
	\n\n\n> Reported with: Disk Use\n
	> Wiki Used:   http://sites-wiki.int.liquidweb.com/display/csops/VPS-+Low+Disk+Space+alert\n\n
	$(titleMain Initial Server Stats)\n
	**| ${format_codeBlock}\n
	===== $(hostname) =====\n\n
	$(titleSec Active Sessions)\n
	$(w)\n\n
	$(titleSec Disk Use)\n
	$(df -h|grep -v docker )\n\n
	$(titleSec RAM Use)\n$(free -h||free -m)\n
	${format_codeBlock}\n\n");

### One-Liner ###
function titleMain(){ printf "###H \033[1;36m${*}\033[0m"; };function titleSec (){ printf "[\033[34m${*}\033[0m]"; };format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="\033[35;1;44m$(printf %3s | tr " " "\`")\033[0m";initialLogin=$(printf %b "\n${format_noteBlock}\n\n\n> Reported with: Disk Use\n> Wiki Used:   http://sites-wiki.int.liquidweb.com/display/csops/VPS-+Low+Disk+Space+alert\n\n$(titleMain Initial Server Stats)\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n$(titleSec Active Sessions)\n$(w)\n\n$(titleSec Disk Use)\n$(df -h|grep -v docker )\n\n$(titleSec RAM Use)\n$(free -h||free -m)\n${format_codeBlock}\n\n");

##########################################################################################################
# v1.1
##########################################################################################################

### v1 Readable ###
	# format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";
	# format_codeBlock="$(printf %3s | tr " " "\`")";
	# initialLogin=$(printf %b "\n${format_noteBlock}
	# 	\n\n\n> Reported with: Disk Use\n\n
	# 	###H Initial Server Stats\n
	# 	**| ${format_codeBlock}\n
	# 	===== $(hostname) =====\n\n
	# 	[Active Sessions]\n
	# 	$(w)\n\n
	# 	[Disk Use]\n
	# 	$(df -h|grep -v docker )\n\n
	# 	[RAM Use]\n$(free -h||free -m)\n
	# 	${format_codeBlock}\n\n");

### v1 Intial Check One-Liner ###
# format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="$(printf %3s | tr " " "\`")";printf %b "\n${format_noteBlock}\n\n\n> Reported with: Disk Use\n\n###H Initial Server Stats\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n[Active Sessions]\n$(w)\n\n[Disk Use]\n$(df -h|grep -v docker )\n\n[RAM Use]\n$(free -h||free -m)\n${format_codeBlock}\n\n";

### v1 Full One-Liner ###
# format_noteBlock="$(printf "%$(tput cols)s\n\tNOTES\n%$(tput cols)s\n" | tr " " "\#")";format_codeBlock="$(printf %3s | tr " " "\`")";initialLogin=$(printf %b "\n${format_noteBlock}\n\n\n> Reported with: Disk Use\n\n###H Initial Server Stats\n**| ${format_codeBlock}\n===== $(hostname) =====\n\n[Active Sessions]\n$(w)\n\n[Disk Use]\n$(df -h|grep -v docker )\n\n[RAM Use]\n$(free -h||free -m)\n${format_codeBlock}\n\n");


#v1# format_codeBlock="$(printf %3s | tr " " "\`")";printf %b "\n\n\n* Checking logged in users\n**| ${format_codeBlock}\n$(w)\n${format_codeBlock}\n\n* Initial Server Stats\n**| ${format_codeBlock}\n[Disk Use]\n$(df -h|grep -v docker )\n\n[RAM Use]\n$(free -h||free -m)\n${format_codeBlock}\n\n\n";

##########################################################################################################
# original
##########################################################################################################
## original ## format_codeBlock="$(printf %3s | tr " " "\`")";printf %b "\n\n\n* Checking logged in users\n${format_codeBlock}\n$(w)\n${format_codeBlock}\n\n* Server Stats\n${format_codeBlock}\n[Disk Use]\n$(df -h|grep -v docker )\n\n[RAM Use]\n$(free -h||free -m)\n${format_codeBlock}\n\n\n";


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P2: Garbage Collection
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Readable ###
printf "\nPurging Wraith & Pruning Docker (this may take some time)\n";
find /home/wraith -mtime +5 -exec rm {} 2>/dev/null \; ;
docker system prune -fa;

### One-Liner ###
find /home/wraith -mtime +5 -exec rm {} 2>/dev/null \; ;docker system prune -fa;

## original ## (find /home/wraith -mtime +5 -exec rm -v {} \; );docker system prune -fa;


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P3: Build Large File List
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##########################################################################################################
# v1.2
##########################################################################################################
## Needs to be implemented (and "fixed")
# listing by large sites (partial from mwp team?/dmcdermitt)
find /home/s*/html/ -maxdepth 0 -type d -exec du -sh '{}' \; | sort -rh | awk '$1~/.+G/ {gsub("/home/",""); gsub("/html/",""); print $2" "$1}' > .mwp-disk-tmp 
	awk '{print "/etc/nginx/sites-enabled/"$1".conf"}' .mwp-disk-tmp | 
		while read conf; do awk '$1~/server_name/ {gsub(";",""); print $2;exit}' $conf; done | 
			paste .mwp-disk-tmp - > .mwp-disk-tmp-sites
largeSites=($(awk '{printf "%6s\t%s\n",$2,$3}' .mwp-disk-tmp-sites))

### Original(ish) ####
find /home/s*/html/ -maxdepth 0 -type d -exec du -sh '{}' \; | sort -rh | awk '$1~/.+G/ {gsub("/home/",""); gsub("/html/",""); print $2" "$1}' > .mwp-disk-tmp 
	awk '{print "/etc/nginx/sites-enabled/"$1".conf"}' .mwp-disk-tmp | 
		while read conf; do awk '$1~/server_name/ {gsub(";",""); print $2;exit}' $conf; done | 
			paste .mwp-disk-tmp - > .mwp-disk-tmp-sites
largesites=($(awk '{printf "%6s\t%s\n",$2,$3}' .mwp-disk-tmp-sites))
#----------------------------------------------------------------------------------

### Readable ###
printf %b "${initialLogin}";
printf %b "\n\n
	$(titleMain Action\(s\) Taken)\n
	** Wraith Purged\n
	**| ${format_codeBlock}\n
	$(printf %s 'find /home/wraith -mtime +5 -exec rm {} \;')\n
	${format_codeBlock}\n
	** Docker Pruned\n
	**| ${format_codeBlock}\n
	$(printf %s 'docker system prune -fa')\n
	${format_codeBlock}\n
	$(titleMain Disk Usage)\n
	** Logs over 500M\n
	**| ${format_codeBlock}\n
	$(find / -not -path /proc -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +500M -exec ls -sh {} \; | awk '{printf "%6s\t%s\n",$1,$2}')\n
	${format_codeBlock}\n\n
	** Directories over 1G:\n
	**| ${format_codeBlock}\n";
dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {printf "%6s\t%s\n",$1,$2}' | sort -rn);
printf %b "
	$(for i in $(echo "$dirs" | awk '{print $2}');do 
		if [ "$(echo "$dirs"| egrep $i -c)" == 1 ];then 
			echo "$dirs"| egrep $i;
		fi;
	done)\n${format_codeBlock}\n\n";

### One-Liner ###
printf %b "${initialLogin}";printf %b "\n\n$(titleMain Action\(s\) Taken)\n** Wraith Purged\n**| ${format_codeBlock}\n$(printf %s 'find /home/wraith -mtime +5 -exec rm {} \;')\n${format_codeBlock}\n** Docker Pruned\n**| ${format_codeBlock}\n$(printf %s 'docker system prune -fa')\n${format_codeBlock}\n$(titleMain Disk Usage)\n** Logs over 500M\n**| ${format_codeBlock}\n$(find / -not -path /proc -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +500M -exec ls -sh {} \; | awk '{printf "%6s\t%s\n",$1,$2}')\n${format_codeBlock}\n\n** Directories over 1G:\n**| ${format_codeBlock}\n";dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {printf "%6s\t%s\n",$1,$2}' | sort -rn);printf %b "$(for i in $(echo "$dirs" | awk '{print $2}');do if [ "$(echo "$dirs"| egrep $i -c)" == 1 ];then echo "$dirs"| egrep $i;fi;done)\n${format_codeBlock}\n\n";


##########################################################################################################
# v1.1
##########################################################################################################
# ### Readable ###
# printf "${initialLogin}";
# printf %b "\n\n
# 	###H Action(s) Taken\n
# 	** Wraith Purged\n
# 	**| ${format_codeBlock}\n
# 	$(printf %s 'find /home/wraith -mtime +5 -exec rm {} \;')\n
# 	${format_codeBlock}\n
# 	** Docker Pruned\n
# 	**| ${format_codeBlock}\n
# 	$(printf %s 'docker system prune -fa')\n
# 	${format_codeBlock}\n
# 	###H Disk Usage\n
# 	** Logs over 500M\n
# 	**| ${format_codeBlock}\n
# 	$(find / -not -path /proc -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +500M -exec ls -sh {} \; | awk '{printf "%6s\t%s\n",$1,$2}')\n
# 	${format_codeBlock}\n\n
# 	** Directories over 1G:\n
# 	**| ${format_codeBlock}\n";
# 	dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {printf "%6s\t%s\n",$1,$2}' | sort -rn);
# printf %b "
# 	$(for i in $(echo "$dirs" | awk '{print $2}');do 
# 		if [ "`echo "$dirs"| egrep $i -c`" == 1 ];then 
# 			echo "$dirs"| egrep $i;
# 		fi;
# 	done)\n${format_codeBlock}\n\n";
# 
# ### One-Liner ###
# printf %b "\n\n\n###H Action(s) Taken\n** Wraith Purged\n**| ${format_codeBlock}\n$(printf %s 'find /home/wraith -mtime +5 -exec rm {} \;')\n${format_codeBlock}\n** Docker Pruned\n**| ${format_codeBlock}\n$(printf %s 'docker system prune -fa')\n${format_codeBlock}\n###H Disk Usage\n** Logs over 500M\n**| ${format_codeBlock}\n$(find / -not -path /proc -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +500M -exec ls -sh {} \; | awk '{printf "%6s\t%s\n",$1,$2}')\n${format_codeBlock}\n\n** Directories over 1G:\n**| ${format_codeBlock}\n";dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {pprintf "%6s\t%s\n",$1,$2}' | sort -rn);printf %b "$(for i in $(echo "$dirs" | awk '{print $2}');do if [ "`echo "$dirs"| egrep $i -c`" == 1 ];then echo "$dirs"| egrep $i;fi;done)\n${format_codeBlock}\n\n"

##########################################################################################################
# original
##########################################################################################################
# ### Original Readable ###
# printf "\n\n\n
# 	* Wraith Purged\n\n
# 	* Docker Pruned\n\n
# 	* Disk Usage\n\`\`\`\n";
# 	echo "> Logs over 100M:";
# 	logs=$(find / -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +100M 2>/dev/null -exec du -k --max=1 {} \;);
# 	echo;
# 	echo "$logs" | sort -k1 -rn | perl -ne '($s,$f)=split(m{\t});for (qw(K M G T)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}';
# 	echo;
# 	echo "> Directories over 1G:";
# 	dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {print $1"    "$2}' | sort -rn);
# 	for i in `echo "$dirs" | awk '{print $2}'`;do
# 		 if [ "`echo "$dirs"| egrep $i -c`" == 1 ];then 
# 		 	echo "$dirs"| egrep $i;
# 		fi ;
# 	done;


#v1# printf %b "\n\n\n* Wraith Purged\n\n* Docker Pruned\n\n* Disk Usage\n** Logs over 500M\n**| ${format_codeBlock}\n$(find / -not -path /proc -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +500M -exec ls -sh {} \; | awk '{printf "%6s\t%s\n",$1,$2}')\n${format_codeBlock}\n\n** Directories over 1G:\n**| ${format_codeBlock}$(dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {print $1"    "$2}' | sort -rn))\n$(for i in `echo "$dirs" | awk '{print $2}'`;do if [ "`echo "$dirs"| egrep $i -c`" == 1 ];then echo "$dirs"| egrep $i;fi;done)\n${format_codeBlock}\n\n"

#original### printf "\n\n\n* Wraith Purged\n\n* Docker Pruned\n\n* Disk Usage\n\`\`\`\n";echo "> Logs over 100M:";logs=$(find / -regex '.*\(log\|\.err\)' -not -path '*virtfs*' -not -path '*docker*' -size +100M 2>/dev/null -exec du -k --max=1 {} \;); echo;echo "$logs" | sort -k1 -rn | perl -ne '($s,$f)=split(m{\t});for (qw(K M G T)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}';echo;echo "> Directories over 1G:";dirs=$(du / -hx 2>/dev/null | awk '$1 ~ /G/ {print $1"    "$2}' | sort -rn);for i in `echo "$dirs" | awk '{print $2}'`;do if [ "`echo "$dirs"| egrep $i -c`" == 1 ];then echo "$dirs"| egrep $i;fi ;done;


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P4: End State of Server 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### Readable ###
printf %b "$(titleMain Ending Disk Space)\n
	**| ${format_codeBlock}\n
	$(df -h | grep -v docker)\n${format_codeBlock}\n"

### One-Liner ###
printf %b "$(titleMain Ending Disk Space)\n**| ${format_codeBlock}\n$(df -h | grep -v docker)\n${format_codeBlock}\n\n\n${format_noteBlock}\n\n"

## original ## printf "\n\`\`\`\n\n* Current Disk space\n\`\`\`\n";df -h | grep -v docker;printf "\n\`\`\`\n"
