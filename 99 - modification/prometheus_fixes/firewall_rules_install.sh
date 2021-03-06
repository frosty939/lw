#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## Checks for csf/apf/firewalld then installs the appropriate rules if they are missing
	## 
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# Test performance of one giant `echo -e`/`print` vs calling it each time
	# Add dupe checks for the fwd rules
	# if csf rules are installed, restart with `csf -ra`
	# add cpHulk check/fixes
	#******************************************************
	#

#-----------------------------------
### Checks for, and removes any blocks for our IPs ###
iptables -nL |grep "\b10\.[2-4][0-1]\.[0-9]" |awk '/DROP|REJECT/{print $4}'|sort -u|xargs -n1 csf -dr
#-----------------------------------

#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



#########################################################################################
### Version 2 ###########################################################################
#########################################################################################
### Checking which fw rules to use
firewalls=(csf apf firewalld);
rules=(lw-csf-rules lp-apf lw-firewalld-rules);
int="0";
gap=$(printf %50s | tr " " "=");
function nul(){ "$@" >/dev/null 2>&1; };
for frontend in ${firewalls[@]}; do
    if nul type $frontend;then
        printf "\nIS installed  [\033[32m$frontend\033[0m]\n";
        if rpm -q ${rules[$int]} > /dev/null ; then
            printf "Rules already installed [\033[32m${rules[$int]}\033[0m]";
        else
			yum install -y ${rules[$int]};
            printf "\n\n\033[32m${rules[$int]}\033[0m rules were installed\n";
        fi;
    else
        printf "\nNOT installed [\033[34m$frontend\033[0m]";
    fi;
    ((int+=1));
    echo;
done
printf "\n$gap\nChecking for Blocked IPs in the Monitoring Range\n";
ipGrab=$(iptables -nL |awk --posix '/[[:blank:]]10\.[2-5][0-1]\.[0-9]{1,2}\.[0-9]{1,3}/ && /DROP|REJECT/ {print $4}'|sort -u);
echo "$ipGrab";
if nul which csf;then
	nul "echo $ipGrab | xargs -n1 csf -dr";
	nul "echo $ipGrab | xargs -n1 csf -tr";
elif nul which apf;then
	nul "echo $ipGrab | xargs -n1 apf -u";
elif [ "$(systemctl is-enabled firewalld.service 2>/dev/null)" == "enabled" ];then
	sshPort=$(awk '!/#/&&/\<[Pp]ort\>/{print $2}' /etc/ssh/sshd_config);
	: ${sshPort:="22"};
    sed -i.lwbak$(date +%Y%m%d) '/End LiquidWeb/i\<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.20.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.30.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.40.11.0/28 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.41.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.50.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>' /etc/firewalld/direct.xml;
    firewall-cmd --complete-reload;
fi;
printf "\nIf there are IPs listed, they were unblocked\n$gap\n";

#-----------------------------------
####### one-line conversion ########
#-----------------------------------
firewalls=(csf apf firewalld);rules=(lw-csf-rules lp-apf lw-firewalld-rules);int="0";gap=$(printf %50s | tr " " "=");function nul(){ "$@" >/dev/null 2>&1; };for frontend in ${firewalls[@]}; do if nul type $frontend;then printf "\nIS installed  [\033[32m$frontend\033[0m]\n";if rpm -q ${rules[$int]} > /dev/null;then printf "Rules already installed [\033[32m${rules[$int]}\033[0m]";else yum install -y ${rules[$int]};printf "\n\n\033[32m${rules[$int]}\033[0m rules were installed\n";fi;else printf "\nNOT installed [\033[34m$frontend\033[0m]";fi;((int+=1));echo;done;printf "\n$gap\nChecking for Blocked IPs in the Monitoring Range\n";ipGrab=$(iptables -nL |awk --posix '/[[:blank:]]10\.[2-5][0-1]\.[0-9]{1,2}\.[0-9]{1,3}/ && /DROP|REJECT/ {print $4}'|sort -u);echo "$ipGrab";if nul which csf;then nul "echo $ipGrab | xargs -n1 csf -dr";nul "echo $ipGrab | xargs -n1 csf -tr";elif nul which apf;then nul "echo $ipGrab | xargs -n1 apf -u";elif [ "$(systemctl is-enabled firewalld.service 2>/dev/null)" == "enabled" ];then sshPort=$(awk '!/#/&&/\<[Pp]ort\>/{print $2}' /etc/ssh/sshd_config);: ${sshPort:="22"};sed -i.lwbak$(date +%Y%m%d) '/End LiquidWeb/i\<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.20.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.30.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.40.11.0/28 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.41.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.50.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>' /etc/firewalld/direct.xml;firewall-cmd --complete-reload;fi;printf "\nIf there are IPs listed, they were unblocked\n$gap\n";

#########################################################################################
### Version 1 ###########################################################################
#########################################################################################
# ### Checking which fw rules to use
# firewalls=(csf apf firewalld)
# rules=(lw-csf-rules lp-apf lw-firewalld-rules)
# int="0"
# for frontend in ${firewalls[@]}; do
#     if type $frontend > /dev/null 2>&1 ;then
#         printf "\nIS installed [\033[32m$frontend\033[0m]\n"
#         if rpm -q ${rules[$int]} > /dev/null ; then
#             printf "Rules already installed [\033[32m${rules[$int]}\033[0m]"
#         else
# 			yum install -y ${rules[$int]}
#             printf "\n\n\033[32m${rules[$int]}\033[0m rules were installed\n"
#         fi
#     else
#         printf "\nNOT installed [\033[34m$frontend\033[0m]"
#     fi
#     ((int+=1))
#     echo
# done
# echo "Checking for Blocked IPs in the Monitoring Range"
# ipGrab=$(iptables -nL |grep "\b10\.[2-4][0-1]\.[0-9]" |awk '/DROP|REJECT/{print $4}'|sort -u)
# echo "$ipGrab"
# if which csf > /dev/null 2>&1;then
# 	echo $ipGrab | xargs -n1 csf -dr >/dev/null 2>&1
# 	echo $ipGrab | xargs -n1 csf -tr >/dev/null 2>&1
# elif which apf > /dev/null 2>&1;then
# 	echo $ipGrab | xargs -n1 apf -u >/dev/null 2>&1
# elif systemctl is-enabled firewalld.service > /dev/null 2>&1; then
#     if [[ $(egrep '^Port' /etc/ssh/sshd_config | awk '{print $2}') ]]; then
#         sshPort=$(egrep '^Port' /etc/ssh/sshd_config | awk '{print $2}')
#     else 
#         sshPort=22
#     fi
#     sed -i.lwbak$(date +%Y%m%d) '/End LiquidWeb/i\<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.20.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.30.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.40.11.0/28 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.41.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.50.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>' /etc/firewalld/direct.xml
#     firewall-cmd --complete-reload
# fi
# printf "\nIf there are IPs listed, they were unblocked\n\n"

	
#-----------------------------------
####### one-line conversion ########
#-----------------------------------
# firewalls=(csf apf firewalld);rules=(lw-csf-rules lp-apf lw-firewalld-rules);int="0";for frontend in ${firewalls[@]};do if type $frontend >/dev/null 2>&1;then printf "\nIS installed [\033[32m$frontend\033[0m]\n";if rpm -q ${rules[$int]} >/dev/null;then printf "Rules already installed [\033[32m${rules[$int]}\033[0m]";else yum install -y ${rules[$int]};printf "\n\n\033[32m${rules[$int]}\033[0m rules were installed\n";fi else printf "\nNOT installed [\033[34m$frontend\033[0m]";fi;((int+=1));echo;done;echo "Checking for Blocked IPs in the Monitoring Range";ipGrab=$(iptables -nL|grep "\b10\.[2-4][0-1]\.[0-9]"|awk '/DROP|REJECT/{print $4}'|sort -u);echo "$ipGrab";if which csf >/dev/null 2>&1;then echo $ipGrab|xargs -n1 csf -dr >/dev/null 2>&1;echo $ipGrab|xargs -n1 csf -tr >/dev/null 2>&1;elif which apf >/dev/null 2>&1;then echo $ipGrab|xargs -n1 apf -u >/dev/null 2>&1;elif systemctl is-enabled firewalld.service >/dev/null 2>&1;then if [[ $(egrep '^Port' /etc/ssh/sshd_config|awk '{print $2}') ]];then sshPort=$(egrep '^Port' /etc/ssh/sshd_config|awk '{print $2}');else sshPort=22;fi;sed -i.lwbak$(date +%Y%m%d) '/End LiquidWeb/i\<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.20.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.30.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.40.11.0/28 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.41.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.50.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>' /etc/firewalld/direct.xml;firewall-cmd --complete-reload;fi;printf "\nIf there are IPs listed, they were unblocked\n\n"


## previous versions (longer, slower)
#firewalls=(csf apf firewalld);rules=(lw-csf-rules lp-apf lw-firewalld-rules);int="0";for frontend in ${firewalls[@]}; do if type $frontend > /dev/null 2>&1 ;then printf "\nIS installed [\033[32m$frontend\033[0m]\n";if rpm -q ${rules[$int]} > /dev/null ; then printf "Rules already installed [\033[32m${rules[$int]}\033[0m]";else yum install -y ${rules[$int]};printf "\n\n\033[32m${rules[$int]}\033[0m rules were installed\n";fi else printf "\nNOT installed [\033[34m$frontend\033[0m]";fi;((int+=1));echo;done;echo "Checking for Blocked IPs in the Monitoring Range";(iptables -nL |grep " 10\.[2-4][0-1]\.[0-9]" |awk '/DROP|REJECT/{print $4}'|sort -u);if which csf > /dev/null 2>&1;then (iptables -nL |grep " 10\.[2-4][0-1]\.[0-9]" |awk '/DROP|REJECT/{print $4}'|sort -u|xargs -n1 csf -dr ) > /dev/null 2>&1;(iptables -nL |grep " 10\.[2-4][0-1]\.[0-9]" |awk '/DROP|REJECT/{print $4}'|sort -u|xargs -n1 csf -tr ) > /dev/null 2>&1;elif which apf > /dev/null 2>&1;then (iptables -nL |grep " 10\.[2-4][0-1]\.[0-9]" |awk '/DROP|REJECT/{print $4}'|sort -u|xargs -n1 apf -u ) > /dev/null 2>&1;elif systemctl is-enabled firewalld.service > /dev/null 2>&1; then if [[ $(egrep '^Port' /etc/ssh/sshd_config | awk '{print $2}') ]]; then sshPort=$(egrep '^Port' /etc/ssh/sshd_config | awk '{print $2}');else sshPort=22;fi;sed -i.lwbak$(date +%Y%m%d) '/End LiquidWeb/i\<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.20.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.30.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.40.11.0/28 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.41.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.50.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>' /etc/firewalld/direct.xml;firewall-cmd --complete-reload;fi;echo "If there are IPs listed, they were unblocked";echo




#########################################################################################
#########################################################################################
#########################################################################################
#########################-----------------------------------#############################
################################ dnemcik's version ######################################
#########################-----------------------------------#############################
#########################################################################################
#########################################################################################
#########################################################################################


#if [[ $(which csf 2>&1 | grep -v "no csf in") ]]
#then 
#    if [[ $(csf -g 10.20.9 | grep DROP) ]] || [[ $(csf -g 10.30.9 | grep DROP) ]] || [[ $(csf -g 10.40.11 | grep DROP) ]] || [[ $(csf -g 10.41.9 | grep DROP) ]] || [[ $(csf -g 10.50.9 | grep DROP) ]]
#    then 
#        if [[ $(rpm -qa | grep lw-csf-rules) ]]
#        then 
#            echo "lw-csf-rules being reinstalled"
#            yum reinstall -y lw-csf-rules
#        else 
#            echo "lw-csf-rules being installed"
#            yum install -y lw-csf-rules
#        fi
#        for i in `csf -g 10.20.9 | grep DROP | awk '{print $11}' | sort | uniq`
#        do
#            echo "Unblocking $i"
#            csf -dr $i
#        done
#        for i in `csf -g 10.30.9 | grep DROP | awk '{print $11}' | sort | uniq`
#        do 
#            echo "Unblocking $i"
#            csf -dr $i
#        done
#        for i in `csf -g 10.40.11 | grep DROP | awk '{print $11}' | sort | uniq`
#        do 
#            echo "Unblocking $i"
#            csf -dr $i
#        done
#        for i in `csf -g 10.41.9 | grep DROP | awk '{print $11}' | sort | uniq`
#        do 
#            echo "Unblocking $i"
#            csf -dr $i
#        done
#        for i in `csf -g 10.50.9 | grep DROP | awk '{print $11}' | sort | uniq`
#        do 
#            echo "Unblocking $i"
#            csf -dr $i
#        done
#    else 
#        echo "MonIPNOTFound"
#    fi
#elif [[ $(which apf 2>&1 | grep -v "no apf in") ]]
#then
#    echo "Running APF"
#elif [[ $(systemctl is-enabled firewalld.service | grep "enabled") ]]
#then
#    if [[ $(egrep '^Port' /etc/ssh/sshd_config | awk '{print $2}') ]]
#    then
#        sshPort=$(egrep '^Port' /etc/ssh/sshd_config | awk '{print $2}')
#    else 
#        sshPort=22
#    fi
#    sed -i.lwbak$(date +%Y%m%d) '/End LiquidWeb/i\<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.20.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.30.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.40.11.0/28 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" #chain="LW_RULES">-s 10.41.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>\n<rule priority="0" table="filter" ipv="ipv4" chain="LW_RULES">-s 10.50.9.0/24 -m tcp -p tcp --dport '"$sshPort"' -j ACCEPT</rule>' /etc/firewalld/direct.xml
#    firewall-cmd --complete-reload
#else 
#    echo "Not running CSF, APF, or Firewalld"
#fi



### Misc Rules & Firewalls to check for 
#which csf;
#which apf;
#which firewalld
#rpm -q lw-csf-rules
#rpm -q lw-firewalld-rules
#rpm -q lp-apf
#rpm -q lw-iptables-rules
#rpm -q lw-hosts-access

##(running 3 `which` appears to be ~40% faster than 1 `which` with 3 arguments)
##(running seperate `rpm -q` for each thing is also faster than a single `rpm -q` with all the arguments. interesting)
	#time rpm -q lw-csf-rules;rpm -q lw-firewalld-rules;rpm -q lp-apf;rpm -q lw-iptables-rules;rpm -q lw-hosts-access

	#time rpm -q lw-csf-rules lw-firewalld-rules lp-apf lw-iptables-rules lw-hosts-access
