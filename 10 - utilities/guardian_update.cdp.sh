#!/bin/bash
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## Checks if cdp-agent is installed and running
	## Checks that the proper `headers` and `devel` kernel modules are installed
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# better checking
	# better noting output
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
### Assigning Colors ###
	blue="\033[34m";	red="\033[31m";
	clr="\033[0m";

### Elevating to root if logged in via 'lwadmin' ###
if [ $(whoami | grep lwadmin) ];then
  printf "\n\nAttempting to elevate to root\n"
  sudo su - || printf "\n${red}"
fi

echo -e "\n\n\n* Updating R1Soft Repo File"
cat <<-'EOF' > /etc/yum.repos.d/r1soft.repo
	[r1soft]
	name=R1Soft Repository Server
	baseurl=http://repo.r1soft.com/yum/stable/$basearch/
	priority=1
	enabled=1
	gpgcheck=0
	EOF
	
echo -e "* Adding exclude to yum repo"
sed -i.lwbak '0,/priority=*/ s/priority=*/&\nexclude=serverbackup*/' /etc/yum.repos.d/*sourcedns.repo*
echo -e "* Updating CDP Agent\n\n\n"
yum update serverbackup-enterprise-agent -q -y
echo -e "\n* Checking Driver Version"
printf "\n\`\`\`\n"
yum info serverbackup-enterprise-agent|grep -E 'Version|Repo'
printf "\n\`\`\`\n"
echo -e "\n\n* Restarting cdp-agent"
/etc/init.d/cdp-agent restart
echo -e "\n\n* Checking if Driver is Running\n\`\`\`"
if [ "$(lsmod | grep hcp)" ];then
	echo Running
else
	echo Failed
	printf "\`\`\`"
	printf "\n\n* Checking current kernel\n\`\`\`\n"
	uname  -r
	rpm -qa | grep "kernel-headers-$(uname -r)"
	rpm -qa | grep "kernel-devel-$(uname -r)"
	printf "\`\`\`\n"

	printf "\n* Checking available kernel\n\`\`\`\n"
	yum -q list kernel | tail -1
	yum -q list kernel-devel | tail -1
	yum -q list kernel-headers | tail -1
	printf "\`\`\`\n"
	printf "\n* Checking for installed kernel headers/devel\n"
	if [ "$(rpm -qa | grep 'kernel-headers-'$(uname -r))" ];then
  		printf "* Header installed for current kernel ["$(rpm -qa | grep 'kernel-headers-'$(uname -r))"]\n"
	else
		printf "* Header Not installed\n"
		printf "** checking if kernel-header can be installed\n"
	if [ "$(yum -q list kernel-headers|grep $(uname -r))" ];then
	    printf "*** Update available installing kernel-headers\n"
	    yum -q -y install kernel-headers-$(name -r)
  	else
	    printf "*** No headers avilable\n"
	    printf "\`\`\`\nCust needs to update kernel\n\`\`\`\n"
  	fi
fi
if [ "$(rpm -qa | grep 'kernel-devel-'$(uname -r))" ];then
  printf "* Devel installed for current kernel ["$(rpm -qa | grep 'kernel-devel-'$(uname -r))"]\n"
else
	printf "* Devel Not installed\n"
	printf "** checking if kernel-devel can be installed\n"
	if [ "$(yum -q list kernel-devel|grep $(uname -r))" ];then
    	printf "*** Update available installing kernel-devel\n"
    	yum -q -y install kernel-devel-$(name -r)
	else
    	printf "*** No devel avilable\n"
    	printf "\`\`\`\nCust needs to update kernel\n\`\`\`\n"
	fi
fi
fi
printf "\n\n"









####################################################################################
######## Original Readable #########################################################
# dmcdermitt #######################################################################
####################################################################################

# if [ "$(whoami | grep lwadmin)" ]
# then
#   echo -e "\n\nChanging to root"
#   sudo su -
# fi
# 
# echo -e "\n\n\n* Updating R1Soft Repo File"
# cat >"/etc/yum.repos.d/r1soft.repo" <<<'[r1soft]|name=R1Soft Repository Server|baseurl=http://repo.r1soft.com/yum/stable/$basearch/|priority=1|enabled=1|gpgcheck=0'
# sed -i 's/|/\n/g' /etc/yum.repos.d/r1soft.repo
# echo -e "* Adding exclude to yum repo"
# sed -i '0,/priority=*/ s/priority=*/&\nexclude=serverbackup*/' /etc/yum.repos.d/*sourcedns.repo*
# echo -e "* Updating CDP Agent\n\n\n"
# yum update serverbackup-enterprise-agent -q -y
# echo -e "\n* Checking Driver Version"
# printf "\n\`\`\`\n"
# yum info serverbackup-enterprise-agent|grep -E 'Version|Repo'
# printf "\n\`\`\`\n"
# echo -e "\n\n* Restarting cdp-agent"
# /etc/init.d/cdp-agent restart
# echo -e "\n\n* Checking if Driver is Running\n\`\`\`"
# if [ "$(lsmod | grep hcp)" ]
# then
# echo Running
# else
# echo Failed
# printf "\`\`\`"
# printf "\n\n* Checking current kernel\n\`\`\`\n"
# uname  -r
# rpm -qa | grep "kernel-headers-$(uname -r)"
# rpm -qa | grep "kernel-devel-$(uname -r)"
# printf "\`\`\`\n"
# 
# printf "\n* Checking available kernel\n\`\`\`\n"
# yum -q list kernel | tail -1
# yum -q list kernel-devel | tail -1
# yum -q list kernel-headers | tail -1
# printf "\`\`\`\n"
# printf "\n* Checking for installed kernel headers/devel\n"
# if [ "$(rpm -qa | grep 'kernel-headers-'$(uname -r))" ]
# then
#   printf "* Header installed for current kernel ["$(rpm -qa | grep 'kernel-headers-'$(uname -r))"]\n"
# else
#   printf "* Header Not installed\n"
#   printf "** checking if kernel-header can be installed\n"
#   if [ "$(yum -q list kernel-headers|grep $(uname -r))" ]
#   then
#     printf "*** Update available installing kernel-headers\n"
#     yum -q -y install kernel-headers-$(name -r)
#   else
#     printf "*** No headers avilable\n"
#     printf "\`\`\`\nCust needs to update kernel\n\`\`\`\n"
#   fi
# fi
# if [ "$(rpm -qa | grep 'kernel-devel-'$(uname -r))" ]
# then
#   printf "* Devel installed for current kernel ["$(rpm -qa | grep 'kernel-devel-'$(uname -r))"]\n"
# else
#   printf "* Devel Not installed\n"
#   printf "** checking if kernel-devel can be installed\n"
#   if [ "$(yum -q list kernel-devel|grep $(uname -r))" ]
#   then
#     printf "*** Update available installing kernel-devel\n"
#     yum -q -y install kernel-devel-$(name -r)
#   else
#     printf "*** No devel avilable\n"
#     printf "\`\`\`\nCust needs to update kernel\n\`\`\`\n"
#   fi
# fi
# fi
# printf "\n\n"
