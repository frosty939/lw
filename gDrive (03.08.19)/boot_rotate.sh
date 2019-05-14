#!/bin/bash

sudo su -
echo;echo --  Notes  --;
echo;echo -- Disk Use:
df -h
orig="$(df -h | grep boot | awk '{print $5}')"
echo;echo -- Current Kernel:
uname -r
echo;echo -- Listing Kernels Installed:
rpm -qa | grep kernel
echo;echo -- Backing Up and Setting instance limit to 2
sed -i.bak 's/installonly_limit=.*/installonly_limit=2/g' /etc/yum.conf
echo;echo -- Removing all but 2 kernels
package-cleanup --oldkernels --count=2 -y
echo;echo -- Listing Kernels Installed:
rpm -qa | grep kernel
echo;echo -- New Disk Use
df -h
new="$(df -h | grep boot | awk '{print $5}')"

if [[ "$orig" == "$new" ]]
then
    echo;echo -- No Change:
    echo Possibly Needs To Upgrade or manual removal needs to occur
fi