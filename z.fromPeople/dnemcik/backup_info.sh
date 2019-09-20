#!/bin/bash

sudo su -
echo;echo --  Notes  --;
echo;echo;
echo =====  Disk Usage
df -h;
echo;echo =====  Retentions:;
egrep -i '(enable|daily|weekly|monthly)' /var/cpanel/backups/config;echo;
echo =====  Final States;
grep -i "final state" /usr/local/cpanel/logs/cpbackup/*;
echo;echo ===== Permission Denied Files; 
LL=`ls /usr/local/cpanel/logs/cpbackup/| tail -n1`; 
grep -i "permission" /usr/local/cpanel/logs/cpbackup/$LL | grep -v preserve | awk '{print $4}' | cut -d: -f1| sort | uniq;
echo;echo =====  Errors from last log;
for logs in  $(ls /usr/local/cpanel/logs/cpbackup/)
do
    echo;echo $(ls -l /usr/local/cpanel/logs/cpbackup/$logs | awk '{print "["$6" "$7"]"}')[$logs] errors:
    egrep -i "Cannot|\.TMD|mysqldump failed|error" /usr/local/cpanel/logs/cpbackup/$logs | egrep -v "(warn|HASH|ARRAY|code, 1|Skipping|recoverable:|Permission)"
done
echo;echo =====  Backups;
timeout 300 du -skxc /backup/* | sort -rn | perl -ne '($s,$f)=split(m{\t});for (qw(K M G T)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}';