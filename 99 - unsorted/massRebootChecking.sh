!#/bin/bash

###########################################################
### readable ##############################################
# Time	=	~22s for 2660 servers #########################
###########################################################
### coloring ###
	end="\033[0m";
	red="\033[0;31m";

### file paths ###
serverList="./serverList";
outputList="./outputList";
  deadList="./deadList";

### Working Bits ###
while : ;do
	# Gathering server repsonses to ping
		printf "\n\tScanning hosts from [ $serverList ]\n";
		nmap -v -sn -T4 -iL $serverList -oG $outputList >/dev/null;

	# pulling out the down ones
		awk '/Down/{printf "[%4s]%15s\t%s\n",$5,$2,$3}' $outputList > $deadList;

	# dashboard
		printf "\n\t${red}[DOWN${end} Servers]\n";
		# cat $deadList
		## rDNS lookup because nmap's seems to fail..
			for serverIP in $(awk '{print $2}' $deadList); do
				rDNS="$(dig -x $serverIP | grep -A1 ANSWER | awk '/PTR/{print $(NF)}' | sed 's/\.$//')";
				printf "%15s\t\t%s\n" $serverIP $rDNS;
			done
	# preventing too much spam
		printf "\n..Waiting 60s..\n";
		sleep 60;
		clear;
done

### one-liner ###
end="\033[0m";red="\033[0;31m";serverList="./serverList";outputList="./outputList";deadList="./deadList";while : ;do printf "\n\tScanning hosts from [ $serverList ]\n";nmap -v -sn -T4 -iL $serverList -oG $outputList >/dev/null;awk '/Down/{printf "[%4s]%15s\t%s\n",$5,$2,$3}' $outputList > $deadList;printf "\n\t${red}[DOWN${end} Servers]\n";for serverIP in $(awk '{print $2}' $deadList); do rDNS="$(dig -x $serverIP | grep -A1 ANSWER | awk '/PTR/{print $(NF)}' | sed 's/\.$//')";printf "%15s\t\t%s\n" $serverIP $rDNS;done; printf "\n..Waiting 60s..\n";sleep 60;clear;done

#==========================================================================================================================================
#==========================================================================================================================================
#==========================================================================================================================================

###########################################################
### dmcdermitt's original(ish) readable ###################
# Time	=	~55s for 2660 servers #########################
###########################################################
end="\033[0m";
red="\033[0;31m";green="\033[0;32m";
printf "\n";
# while [ "$(cat serverList)" ];	do
	 for p in $(cat serverList);do
		printf "\rChecking: ${p}";
		if [ "${p}" ];then 
			if [ ! "$(timeout 0.1 ping -c1 $p | grep ms)" ];then 
				printf "${p}\n" >> deadList;
			fi;
		fi;
	done;
	clear; 
	if [ "$(cat deadList)" ];then
		 printf "\n\nDown Servers:\n";
		for i in $(cat deadList);do 
			printf "$red${i} down\n$end";
	 	done;s=$(wc -l serverList|awk '{print $1}');
		d=$(wc -l deadList|awk '{print $1}');
		printf "Total Down: $(wc -l deadList)\n
				Completed: $(($s-$d))\n
				Total Servers: $(wc -l serverList)\n
				Goal: 2888\n
				Remaining: $((2888 - $(wc -l serverList | awk '{print $1}')))\n";
	fi;>deadList;sleep 10;printf "\n";
# done


### dmcdermitt's original one-liner ###
end="\033[0m";red="\033[0;31m";green="\033[0;32m";printf "\n";while [ "$(cat servers)" ];do for p in $(cat servers);do printf "\rChecking: ${p}";if [ "${p}" ];then if [ ! "$(timeout 0.1 ping -c1 $p | grep ms)" ];then printf "${p}\n">>down_servers;fi;fi;done;clear; if [ "$(cat down_servers)" ];then printf "\n\nDown Servers:\n";for i in $(cat down_servers);do printf "$red${i} down\n$end";done;s=$(wc -l servers|awk '{print $1}');d=$(wc -l down_servers|awk '{print $1}');printf "Total Down: $(wc -l down_servers)\nCompleted: $(($s-$d))\nTotal Servers: $(wc -l servers)\nGoal: 2888\nRemaining: $((2888 - $(wc -l servers | awk '{print $1}')))\n";fi;>down_servers;sleep 10;printf "\n";done
