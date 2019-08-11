#!/bin/bash
echo "Calculating Disk Space Usage. Please wait."

df -h | egrep "^/dev/"

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


backuplist="-iname \"backupwordpress*\" -o -iname \"ai1m*\" -o -iname \"updraft\""

tpbackups=($(echo "find /home/s*/html/wp-content/ -maxdepth 1 -type d  "$backuplist"" | bash |
         xargs du -sh | awk '$1~/G/ {gsub("/home/",""); gsub("/html/wp-content/",":"); print $2":"$1}'))


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

find /home/wraith -mtime +5 -exec rm {} \; 2> /dev/null
docker system prune -fa

df -h | egrep "^/dev/"

echo -e "${GREEN}───────────────────────┤${NC} RESPONSE TEMPLATE ${GREEN}├──────────────────────────${NC}"
echo -e "${GREEN}──────────────────────────────────────────────────────────────────────${NC}"
