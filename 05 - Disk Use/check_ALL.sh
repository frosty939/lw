#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
# Created by:	Wayne Boyer
#=======================================================================================
	## Scans entire system for large files and prints them out in a formated list
	## 
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# better colorizing
	# optimize searching
	# remove useless awk algebra(wrong word, but can't think of the right one..) and replcae with ls -sh
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


###############################################################################
# v1.2 One-Liner
###############################################################################
printf "\n(\033[34mThis may take a while\033[0m)\n\n";(find / -not -path "/home/virtfs/*" -not -path "/proc/*" -not -path "/run/*" -not -path "/backup*/*" -not -path "/usr/share/cagefs-skeleton/proc/*" -not -name "*tmpDSK*" -type f -size +200M -exec ls -sh '{}' \; | awk '{printf "%6s\t%s\n",$1,$2}')|sort -rn;printf "\n\n"


####################################################################################
######## v1.3 Readable #############################################################
####################################################################################
# (prune just doesn't seem to work. no matter what)
printf "\n(\033[34mThis may take a while\033[0m)\n\n";
	(find / \
		\( -name "/home/virtfs" \
		-o -name "/proc" \
		-o -name "/run" \
		-o -name "/backup*" \
		-o -name "/usr/share/cagefs-skeleton/proc" \
		\) -prune -not -name "*tmpDSK*" \
		-o \
		-type f \
		-size +500M \
		-exec ls -sh '{}' \; | awk '{printf "%6s\t%s\n",$1,$2}' )\
		| sort -rn;
printf "\n\n"

printf "\n(\033[34mThis may take a while\033[0m)\n\n";(find / \( -name "/home/virtfs" -o -name "/proc" -o -name "/run" -o -name "/backup*" -o -name "/usr/share/cagefs-skeleton/proc" \) -prune -not -name "*tmpDSK*" -o -type f -size +500M -exec ls -sh '{}' \; | awk '{printf "%6s\t%s\n",$1,$2}' )| sort -rn;printf "\n\n"


####################################################################################
######## v1.1 Readable #############################################################
####################################################################################
printf "\n(\033[34mThis may take a while\033[0m)\n\n";
	find / \
		-not -path "/home/virtfs/*" \
		-not -path "/proc/*" \
		-not -path "/run/*" \
		-not -path "/backup*/*" \
		-not -path "/usr/share/cagefs-skeleton/proc/*" \
		-not -name "*tmpDSK*" \
		-type f \
		-size +500M \
		-exec ls -sh '{}' \; | awk '{printf "%6s\t%s\n",$1,$2}'
printf "\n\n"

####################################################################################
######## v1.1 One-Liner ############################################################
####################################################################################
printf "\n(\033[34mThis may take a while\033[0m)\n\n";find / -not -path "/home/virtfs/*" -not -path "/proc/*" -not -path "/run/*" -not -path "/backup*/*" -not -path "/usr/share/cagefs-skeleton/proc/*" -not -name "*tmpDSK*" -type f -size +200M -exec ls -sh '{}' \; | awk '{printf "%6s\t%s\n",$1,$2}';printf "\n\n"


#=================================================================================================================
#=================================================================================================================
#=================================================================================================================
#=================================================================================================================
#=================================================================================================================

####################################################################################
######## Original Readable #########################################################
####################################################################################

printf "\n(\033[34mThis may take a while\033[0m)\n\n";
	find / \
		-not -path "/home/virtfs/*" \
		-not -path "/proc/*" \
		-not -path "/run/*" \
		-not -path "/backup*/*" \
		-not -name "*tmpDSK*" \
		-type f \
		-size +200M \
		-exec ls -la '{}' \; | awk '
								BEGIN{
									pref[1]="K";
									pref[2]="M";
									pref[3]="\033[33mG\033[0m";
									pref[4]="T"
								} {
									x = $5;
									y = 0;
									while( x > 1024 ) {
										 x = x/1024; y++; 
									} 
									printf("%6g%s\t %s\n",int(x*10+.5)/10,pref[y],$9);
									sum += $5
								} END {
									print "Total:" sum/1024**3 " G" }';
printf "\n\n"




####################################################################################
######## Original One-Liner ########################################################
####################################################################################
printf "\n(\033[34mThis may take a while\033[0m)\n\n";find / -not -path "/home/virtfs/*" -not -path "/proc/*" -not -path "/run/*" -not -path "/backup*/*" -not -name "*tmpDSK*" -type f -size +200M -exec ls -la '{}' \; | awk 'BEGIN{pref[1]="K";pref[2]="M";pref[3]="\033[33mG\033[0m";pref[4]="T"} {x = $5; y = 0; while( x > 1024 ) { x = x/1024; y++; } printf("%6g%s\t %s\n",int(x*10+.5)/10,pref[y],$9); sum += $5} END {print "Total:" sum/1024**3 " G" }';printf "\n\n"
			 
			 
			 
###############################################################################
# Original
###############################################################################
printf "\n\n";find / -not -path "/home/virtfs/*" -not -path "/proc/*" -not -path "/run/*" -not -path "/backup*/*" -not -name "*tmpDSK*" -type f -size +200M -exec ls -la '{}' \; | awk 'BEGIN{pref[1]="K";pref[2]="M";pref[3]="G";pref[4]="T"} {x = $5; y = 0; while( x > 1024 ) { x = x/1024; y++; } printf("%g%s\t%s %s %s\n",int(x*10+.5)/10,pref[y],$6,$7,$9); sum += $5} END {print "Total:" sum/1024**3 " G" }';printf "\n\n"
