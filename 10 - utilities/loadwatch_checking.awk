#!/bin/bash
####################################################################################
######## Original Readable #########################################################
####################################################################################
# need to fix the column width of the load values
# need to sort the results.. completely random(ish) at this points
####################
(find /root/loadwatch/ /var/log/loadwatch/ -name "*$(date +%Y-%m-%d)*" -o -name "*$(date -d yesterday +%Y-%m-%d)*" -exec awk \ 
	-F",| " \
	-v cores=$(nproc) \
	-v red="\033[31m" \
	-v orange="\033[33m" \
	-v green="\033[32m" \
	-v fresh="\033[0m" \
 	'/^top.+load average/{
		if($(NF-4) > cores * 1.5)
			$1=red$(NF-4)fresh
		else if($(NF-4) > cores && $(NF-4) <= cores * 1.5)
			$1=orange$(NF-4)fresh
		else if($(NF-4) < cores)
			$1=green$(NF-4)fresh
		
		if($(NF-2) > cores * 1.5)
			$2=red$(NF-2)fresh
		else if($(NF-2) > cores && $(NF-2) <= cores * 1.5)
			$2=orange$(NF-2)fresh
		else if($(NF-2) < cores)
			$2=green$(NF-2)fresh
		
		if($(NF-0) > cores * 1.5)
			$3=red$(NF-0)fresh
		else if($(NF-0) > cores && $(NF-0) <= cores * 1.5)
			$3=orange$(NF-0)fresh
		else if($(NF-0) < cores)
			$3=green$(NF-0)fresh
		
	;printf "%-50s %6s %6s %6s\n",FILENAME,$1,$2,$3}' {} \;) 2>/dev/null || printf "\nNo Loadwatch Files found for Today\n"

####################################################################################
######## One-Liner #################################################################
####################################################################################
### just today ##
(find /root/loadwatch/ /var/log/loadwatch/ -name "*$(date +%Y-%m-%d)*" -exec awk -F",| " -v cores=$(nproc) -v red="\033[31m" -v orange="\033[33m" -v green="\033[32m" -v fresh="\033[0m" '/^top.+load average/{if($(NF-4) > cores * 1.5)$1=red$(NF-4)fresh;else if($(NF-4) > cores && $(NF-4) <= cores * 1.5)$1=orange$(NF-4)fresh;else if($(NF-4) < cores)$1=green$(NF-4)fresh;if($(NF-2) > cores * 1.5)$2=red$(NF-2)fresh;else if($(NF-2) > cores && $(NF-2) <= cores * 1.5)$2=orange$(NF-2)fresh;else if($(NF-2) < cores)$2=green$(NF-2)fresh;if($(NF-0) > cores * 1.5)$3=red$(NF-0)fresh;else if($(NF-0) > cores && $(NF-0) <= cores * 1.5)$3=orange$(NF-0)fresh;else if($(NF-0) < cores)$3=green$(NF-0)fresh;printf "%-50s %s %s %s\n",FILENAME,$1,$2,$3}' {} \;) 2>/dev/null || printf "\nNo Loadwatch Files found for Today\n"

### today, or yesterday ##
(find /root/loadwatch/ /var/log/loadwatch/ -name "*$(date +%Y-%m-%d)*" -o -name "*$(date -d yesterday +%Y-%m-%d)*" -exec awk -F",| " -v cores=$(nproc) -v red="\033[31m" -v orange="\033[33m" -v green="\033[32m" -v fresh="\033[0m" '/^top.+load average/{if($(NF-4) > cores * 1.5)$1=red$(NF-4)fresh;else if($(NF-4) > cores && $(NF-4) <= cores * 1.5)$1=orange$(NF-4)fresh;else if($(NF-4) < cores)$1=green$(NF-4)fresh;if($(NF-2) > cores * 1.5)$2=red$(NF-2)fresh;else if($(NF-2) > cores && $(NF-2) <= cores * 1.5)$2=orange$(NF-2)fresh;else if($(NF-2) < cores)$2=green$(NF-2)fresh;if($(NF-0) > cores * 1.5)$3=red$(NF-0)fresh;else if($(NF-0) > cores && $(NF-0) <= cores * 1.5)$3=orange$(NF-0)fresh;else if($(NF-0) < cores)$3=green$(NF-0)fresh;printf "%-50s %s %s %s\n",FILENAME,$1,$2,$3}' {} \;) 2>/dev/null || printf "\nNo Loadwatch Files found for Today\n"


####################################################################################
####################################################################################
####################################################################################
####################################################################################

#######
# the find part
#######
# find /root/loadwatch/ /var/log/loadwatch/ -name "*$(date +%Y-%m-%d)*" -exec awk '/^top.+load average/{print FILENAME,$(NF-2),$(NF-1),$(NF-0);exit;}' {} \; |column -t
##the "exit;" in the awk kills the awk as soon as it finds a result.. maybe? probably using it wrong though



#######
# testing if/then + comparison
#######
# test if its faster to compare each 3 times, or compare all at once then color
#awk	-F',' -v cores=$(nproc) \
#	-v red="\033[31m" \
#	-v orange="\033[33m" \
#	-v green="\033[32m" \
#	-v fresh="\033[0m" \
# 	'{
#		if($(NF-2) > cores * 1.5)
#			$1=red$(NF-2)fresh
#		else if($(NF-2) > cores && $(NF-2) <= cores * 1.5)
#			$1=orange$(NF-2)fresh
#		else if($(NF-2) < cores)
#			$1=green$(NF-2)fresh
#		
#		if($(NF-1) > cores * 1.5)
#			$2=red$(NF-1)fresh
#		else if($(NF-1) > cores && $(NF-1) <= cores * 1.5)
#			$2=orange$(NF-1)fresh
#		else if($(NF-1) < cores)
#			$2=green$(NF-1)fresh
#		
#		if($(NF-0) > cores * 1.5)
#			$3=red$(NF-0)fresh
#		else if($(NF-0) > cores && $(NF-0) <= cores * 1.5)
#			$3=orange$(NF-0)fresh
#		else if($(NF-0) < cores)
#			$3=green$(NF-0)fresh
#		
#	}{printf "%-50s %s %s %s\n",FILENAME,$1,$2,$3}' ./testData.awk
	
	
#-----------------------------------
#-----------------------------------
#
#
#
#
##### testing if/then + comparison
## test if its faster to compare each 3 times, or compare all at once then color
#awk -v cores=$(nproc) '\
#        if($(NF-2) < cores && $(NF-1) < cores && $(NF-0) < cores)
#		 	{printf "\033[32m%s\033[0m\n", $(NF-2),$(NF)}
#
#
#
#
#        NF-1 > cores
#		{printf "\033[33m%s\033[0m\n", NF-1}
#
#
#        NF-0 >= cores * 2 
#		{printf "\033[31m%s\033[0m\n", NF-0}
#		
#        ' /var/log/loadwatch/2019-04-29-28.04.12.txt
#
#
#
#
#
#
##### Test and print color
#awk -v cores=$(nproc) '\
#        $1 < cores {printf "\033[32m"}
#        {printf "%s\033[0m\n", $1}
#
#        $2 > cores {printf "\033[33m"}
#        {printf "%s\033[0m\n", $2}
#
#        $3 >= cores * 2 {printf "\033[31m"}
#        {printf "%s\033[0m\n", $3}
#        '
#
#
#		-----------------------------------
#		-----------------------------------
#		-----------------------------------
#		-----------------------------------
##### using the `color.awk` file to assign colors and make them "easy" to read
#	awk -f color.awk -e '{$1 = RED($1); $2 = BG_RED($2);print}' /var/log/loadwatch/2019-04-29-28.04.12.txt
