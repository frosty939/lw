#!/bin/bash
########
# Modified: Readable
########
# removed touch
#-----------------------------------
### sets the save location
(
	clear;
	info1="/home/$(hostname)-$(date +"%F-%T".txt)";
	blue="\033[34m";
	red="\033[31m";
	clr="\033[0m";
	#gap="$(printf '=%.0s' {1..40})"
	gap="$blue$(printf %60s |tr " " "=")$clr"
	### lets me null stuff without repeating it everywhere
	function nul(){ "$@" 2>/dev/null;};

	echo -e "
		\n$gap\nGeneral\n$gap
		[Hostname]  $(hostname)
		[      OS] $(nul cat /etc/redhat-release || (hostnamectl |awk -F: '/Op/{print $(NF)}'))
		[   Cores]  $(nproc)\n$gap
		  $(w |tail -n +2)\n
		\n$gap\nMemory\n$gap\n$(nul free -h || free -m)
		\n\n$(df -h| grep -v tmpfs)
		\n\nApache info:
		\nEA4: $(if [ -f /etc/cpanel/ea4/is_ea4 ]; then echo 'Yes'; else echo 'No'; fi)
		\n$(httpd -V|head -9|grep -E '(version|built|MPM)')
		
		\n\nPHP info: 
	
		\n$(/usr/local/cpanel/bin/rebuild_phpconf --current)
		
		\n\nMySQL info:"
)
	# printf "
	# 	$(
	# 	echo -e "\nMysql Mem configured settings: " && awk '/(key|i.*b)_b.*r_(pool_)?(s.*|.*es)/{sub("="," "); print $1,$2}' /etc/my.cnf && 
	# 	echo -e "\nMysql Mem current settings: " && mysql -e "show variables" |awk '/(key|innodb)_buffer_(pool_)?(size|.*es)/{if($1~/.*es/)print$1,$2; else print$1,$2/1048576"M"}' && 
	# 		echo -e "\nMysql Mem suggested settings :" && mysql -Bse 'show variables like "datadir";'|awk '{print $2}'|xargs -I{} find {} -type f -printf "%s %f\n"|awk -F'[ ,.]' '{print $1, $NF}'|
	# 			awk '{
	# 				array[$2]+=$1
	# 				} END {
	# 				for (i in array) 
	# 					{printf("%-15s %s\n", sprintf("%.3f MB", array[i]/1048576), i)}
	# 				}' |
	# 				awk '{
	# 					if($3~/MYI/)print"key_buffer_size\t\t> ",$1"M"
	# 					};
	# 					{
	# 					if($3~/ibd/)a+=$1
	# 						} END {
	# 						print "innodb_buffer_pool_size\t> ",a"M"
	# 					}'
	# 	)" >> $info1; 
	# 
	# echo -e "\nVirtualhost files: " ;
	# echo $(find  /usr/local/apache/conf/includes/ -name 'pre*' -name '*.conf' ! -name 'error*' -size +0) ;
	# sed "s/\/usr/\\n\/usr/g" $info1







####################################################################################
######## Original Readable #########################################################
####################################################################################
#(info1=/home/$(hostname)-$(date +"%F-%T".txt);
#touch $info1;
#echo -e "
#\nHostname: $(hostname)
#
#
#\n\n$(hostnamectl | grep Operating)
#
#
#\n\nCores: $(nproc)\n\n$(w)
#
#
#\n\n$(free -m)
#
#
#\n\n$(df -h| grep -v tmpfs)
#
#\n\nApache info:
#
#\n$(httpd -V|head -9|grep -E '(version|built|MPM)')
#
#
#\n\nEA4: $(if [ -f /etc/cpanel/ea4/is_ea4 ]; then echo 'Yes'; else echo 'No'; fi)
#
#
#\n\nPHP info: 
#
#\n$(/usr/local/cpanel/bin/rebuild_phpconf --current)
#
#
#\n\nMySQL info:">> $info1; 
#
#echo -e "
#	$(
#	echo -e "
#		\nMysql Mem configured settings: " && 
#		awk '/(key|i.*b)_b.*r_(pool_)?(s.*|.*es)/{sub("="," "); print $1,$2}' /etc/my.cnf && 
#		echo -e "
#			\nMysql Mem current settings: " && mysql -e "show variables" |awk '/(key|innodb)_buffer_(pool_)?(size|.*es)/{if($1~/.*es/)print$1,$2; else print$1,$2/1048576"M"}' && 
#			echo -e "
#				\nMysql Mem suggested settings :" && mysql -Bse 'show variables like "datadir";'|awk '{print $2}'|xargs -I{} find {} -type f -printf "%s %f\n"|awk -F'[ ,.]' '{print $1, $NF}'|
#				awk '{
#					array[$2]+=$1
#					} END {
#					for (i in array) 
#						{printf("%-15s %s\n", sprintf("%.3f MB", array[i]/1048576), i)}
#					}' |
#					awk '{
#						if($3~/MYI/)print"key_buffer_size\t\t> ",$1"M"
#						};
#						{
#						if($3~/ibd/)a+=$1
#							} END {
#							print "innodb_buffer_pool_size\t> ",a"M"
#						}'
#	)" >> $info1; 
#	echo -e "\nVirtualhost files: " >>$info1; 
#	echo $(find  /usr/local/apache/conf/includes/ -name 'pre*' -name '*.conf' ! -name 'error*' -size +0) >> $info1;  sed "s/\/usr/\\n\/usr/g" $info1)



####################################################################################
######## Original One-Liner ########################################################
####################################################################################
#https://wiki.wgoff.com/home/basic/first-server-check

#(info1=/home/$(hostname)-$(date +"%F-%T".txt); touch $info1;echo -e "\nHostname: $(hostname)\n\n$(hostnamectl | grep Operating)\n\nCores: $(nproc)\n\n$(w)\n\n$(free -m)\n\n$(df -h| grep -v tmpfs)\n\nApache info:\n$(httpd -V|head -9|grep -E '(version|built|MPM)')\n\nEA4: $(if [ -f /etc/cpanel/ea4/is_ea4 ]; then echo 'Yes'; else echo 'No'; fi)\n\nPHP info: \n$(/usr/local/cpanel/bin/rebuild_phpconf --current)\n\nMySQL info:">> $info1; echo -e "$(echo -e "\nMysql Mem configured settings: " && awk '/(key|i.*b)_b.*r_(pool_)?(s.*|.*es)/{sub("="," "); print $1,$2}' /etc/my.cnf && echo -e "\nMysql Mem current settings: " && mysql -e "show variables" |awk '/(key|innodb)_buffer_(pool_)?(size|.*es)/{if($1~/.*es/)print$1,$2; else print$1,$2/1048576"M"}' && echo -e "\nMysql Mem suggested settings :" && mysql -Bse 'show variables like "datadir";'|awk '{print $2}'|xargs -I{} find {} -type f -printf "%s %f\n"|awk -F'[ ,.]' '{print $1, $NF}'|awk '{array[$2]+=$1} END {for (i in array) {printf("%-15s %s\n", sprintf("%.3f MB", array[i]/1048576), i)}}' | awk '{if($3~/MYI/)print"key_buffer_size\t\t> ",$1"M"};{if($3~/ibd/)a+=$1}END{print "innodb_buffer_pool_size\t> ",a"M"}')" >> $info1; echo -e "\nVirtualhost files: " >>$info1; echo $(find  /usr/local/apache/conf/includes/ -name 'pre*' -name '*.conf' ! -name 'error*' -size +0) >> $info1;  sed "s/\/usr/\\n\/usr/g" $info1)
