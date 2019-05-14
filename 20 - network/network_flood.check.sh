



tdStep01="/tmp/tdStep01"
tdStep02="/tmp/tdStep02"
tdStep03="/tmp/tdStep03"
tdStep04="/tmp/tdStep04"
# gathering base info
	timeout 5 tcpdump 2> /dev/null -nnqt ether dst `ip addr show eth0 | grep ether | awk '{print $2}'` > $tdStep01
# sorting and filtering
	awk '{print $4,$5}' $tdStep01 | sort | uniq -c | sort -n | awk '$1 != 1' > $tdStep02

timeout 7 tcpdump -nnqt dst host $dstIP and $proto dst port $dstPort > out
printf "\n\e[1;33m[OMITTING IPs WITH A SINGLE CONNECTION]\e[0m\n\n"

-----------------------------------
-----------------------------------



awk '{print $2}' $tdStep02 | sed -r 's|([[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}).*$|\1|g'
	
awk '{print $1,$2}' $tdStep02 | sed -r 's|([[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3})(.*$)|\1 \2|g'

awk '{print $1,$2}' $tdStep02 | sed -r 's|([[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3})\.(.{1,5}):$|\1 \2|g' |
 tail -1 > $tdStep03

# omits IPs with only 1 connection
	awk '{print $1,$2}' $tdStep02 | sed -r 's|([[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3})(.*$)|\1 \2|g'

-----------------------------------
-----------------------------------
$(awk '{print $2}' $tdStep03)
$(awk '{print $3}' $tdStep03)
#listening for specific traffic

	timeout 7 tcpdump -nnqt dst host $(awk '{print $2}' $tdStep03) and dst port $(awk '{print $3}' $tdStep03) > $tdStep04
