#!/bin/bash
#### https://git.liquidweb.com/nkernreicht/lw-mwp-disk-usage/blob/master/lw-mwp-disk-usage.sh
# Created by: nkernreicht
# MWP disk use investigation
###################################################################################################

echo "Calculating Disk Space Usage. Please wait."

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' 

wraithdu="$(du -sh /home/wraith/ | awk '{print $1}')"
nginxerr="$(du -ch $(find /var/log/nginx -type f -iname "*error.log*") | awk '$2~/total/ {print $1}')"
nginxacc="$(du -ch $(find /var/log/nginx -type f -iname "*access.log*") | awk '$2~/total/ {print $1}')"
dbtotal="$(du -ch /var/lib/mysql | awk '$2~/total/ {print $1}')"
dockerdu="$(du -sch /var/lib/docker | awk '$2~/total\>/ {print $1}')"
freetarget="$(df -h | awk '$NF~/\/$/ {gsub("G",""); print $2*.2-$4"G"}')"


uploadtotal="$(du -sch /home/s*/html/wp-content/uploads | awk '$2~/total\>/ {print $1}')"
plugintotal="$(du -sch /home/s*/html/wp-content/plugins | awk '$2~/total\>/ {print $1}')"


largeuploads="$(find /home/s*/html/wp-content/uploads/ -maxdepth 0 -type d -exec du -sh '{}' \; | sort -rh | 
awk '$1~/.+G/ {gsub("/home/",""); gsub("/html/wp-content/uploads/",""); print $2":"$1}')"

largeplugins="$(find /home/s*/html/wp-content/plugins/ -maxdepth 0 -type d -exec du -sh '{}' \; | sort -rh | 
awk '$1~/.+G/ {gsub("/home/",""); gsub("/html/wp-content/plugins/",""); print $2":"$1}')"


backuplist="-iname \"backupwordpress*\" -o -iname \"ai1m*\" -o -iname \"updraft\" -o -iname \"backupbuddy*\""

tpbackups=($(echo "find /home/s*/html/wp-content/ -maxdepth 2 -type d  "$backuplist"" | bash |
		 xargs du -sh | awk '$1~/G/ {gsub("/home/",""); gsub("/html/wp-content/[a-z]+/",":"); print $2":"$1}' > .tpdisk-tmp 
		 awk -F ":" '{print $1}' .tpdisk-tmp | while read snum; do 
							awk '$1~/server_name/ {gsub(";",""); print $2;exit}' /etc/nginx/sites-enabled/$snum.conf ; done | paste -d ":" .tpdisk-tmp - >> .tpdisk2-tmp
awk -F ":" '{print $4":"$2":"$3}' .tpdisk2-tmp))

rm .tpdisk2-tmp
rm .tpdisk-tmp

	find /home/s*/html/ -maxdepth 0 -type d -exec du -sh '{}' \; | sort -rh | awk '$1~/.+G/ {gsub("/home/",""); gsub("/html/",""); print $2" "$1}' > .mwp-disk-tmp 
		awk '{print "/etc/nginx/sites-enabled/"$1".conf"}' .mwp-disk-tmp | 
			while read conf; do awk '$1~/server_name/ {gsub(";",""); print $2;exit}' $conf; done | 
				paste .mwp-disk-tmp - >> .mwp-disk-tmp-sites
	largesites=($(awk '{print $3":"$2}' .mwp-disk-tmp-sites))
	
	rm .mwp-disk-tmp
	rm .mwp-disk-tmp-sites


function column_format () {
tr ' ' '\n' | tr ':' '\t' | column -t
}

clear
echo ""
echo ""
echo -e "${RED}───────────────────────┤${NC} SUPPORT RELATED ${RED}├────────────────────────────${NC}"
echo "Wraith Disk Usage:    $wraithdu"
echo "Nginx Error Logs:     $nginxerr"
echo "Nginx Access Logs:    $nginxacc"
echo "Docker Usage:         $dockerdu"
echo "Space needed to Free: $freetarget"
echo -e "${RED}──────────────────────────────────────────────────────────────────────${NC}"
echo ""
echo ""


echo -e "${BLUE}───────────────────────┤${NC} CUSTOMER RELATED ${BLUE}├───────────────────────────${NC}"
echo "Total Uploads Size:  $uploadtotal"
echo "Total Plugins Size:  $plugintotal"
echo "Total Database Size: $dbtotal"
echo ""

if [[ "${largeuploads[*]}" != "" ]]; then
echo -e "${YELLOW}────┤ Large Upload Directories ├────${NC}"
echo "$(echo ${largeuploads[*]} | column_format )"
echo ""
fi

if [[ "${largeplugins[*]}" != "" ]]; then
echo -e "${YELLOW}────┤ Large Plugin Directories ├────${NC}"
echo "$(echo ${largeplugins[*]} | column_format )"
echo ""
fi

if [[ "${tpbackups[*]}" != "" ]]; then
echo -e "${YELLOW}────┤ Third Party Backups ├────${NC}"
echo "$(echo ${tpbackups[*]} | column_format )"
echo ""
fi

if [[ "${largesites[*]}" != "" ]]; then
echo -e "${YELLOW}────┤ Large Sites ├────${NC}"
echo "$(echo ${largesites[*]} | column_format )"
echo -e "${BLUE}──────────────────────────────────────────────────────────────────────${NC}"
echo ""
echo ""
fi

echo -e "${GREEN}───────────────────────┤${NC} RESPONSE TEMPLATE ${GREEN}├──────────────────────────${NC}"
echo "Hello,"
echo "Our monitoring systems have recently indicated that your Managed WordPress instance has reached critical disk usage threshold. Currently your instance has $(df -h | awk '$NF~/\/$/{print $2}') of total disk space, and is using $(df -h | awk '$NF~/\/$/{print $3}'). In order to insure system stability and to prevent data corruption, or site downtime, $freetarget of space should be freed up so that the system can work properly."
echo "The following sites are fairly large and should be investigated to determine if anything can be removed in order to save disk space."
echo "$(echo ${largesites[*]} | column_format)"
if [[ "${tpbackups[*]}" != "" ]]; then
echo "There also appears to be Third Party backup plugins enabled on your Managed WordPress instance. The Managed WordPress platform includes automatic backups which are stored on Cloud Storage and do not effect the disk space on your server. Because of this third party backup plugins are redundant and can negatively effect the disk space usage of the Managed WordPress instance. The following are the sites which have third party backups enabled, and the plugins themselves are using the denoted amount of disk space. It is recommended that these plugins be removed and the backups they have taken be removed off the system. "
echo "$(echo ${tpbackups[*]} | column_format )"
fi
echo "Please let us know if you have any questions regarding any information discussed in this notification, or if you require any assistance in resolving these disk space issues. If you are unable to free any space, please let us know so that we can work together to find a solution that will help alleviate these disk space issues."
echo "Thank you,"
echo -e "${GREEN}──────────────────────────────────────────────────────────────────────${NC}"
