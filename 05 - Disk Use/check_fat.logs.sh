





#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P0: FULL ONE-LINER
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### v1.3 ###
printf "\n(\033[34mThis may take a while\033[0m)\n\n\n"; (find /home /var/log /var/lib/ -regextype posix-extended -not -path "/home/virtfs/*" -name "*log*" -and -not -regex ".*\.(MY[DI]|ibd)" -type f -size +200M -exec ls -sh '{}' \; | awk '{printf "%6s\t%s\n",$1,$(NF)}') | sort -rn; printf "\n\n"
### v1.2 ###
# using `-prune` SHOULD be faster than `-not -path`.. but its not..?
printf "\n(\033[34mThis may take a while\033[0m)\n\n\n"; (find /home /var/log /var/lib/ -name "*log*" -and -not -name "*.ibd" -not -path "/home/virtfs/*" -type f -size +200M -exec ls -sh '{}' \; | awk '{printf "%6s\t%s\n",$1,$(NF)}') | sort -rn;printf "\n\n"


### v1.1 ###
# printf "\n\n";find /home /var/log /var/lib/ -name "*log*" -and -not -name "*.ibd" -not -path "/home/virtfs/*" -type f -size +200M -exec ls -ls '{}' \; | awk '{printf "%6s\t%s\n",$1,$2}';printf "\n\n"

### ~Original ###
# printf "\n\n";find /home /var/log /var/lib/ -name "*log*" -and -not -name "*.ibd" -not -path "/home/virtfs/*" -type f -size +200M -exec ls -la '{}' \; | awk 'BEGIN{pref[1]="K";pref[2]="M";pref[3]="G";pref[4]="T"} {x = $5; y = 0; while( x > 1024 ) { x = x/1024; y++; } printf("%g%s\t%s %s %s\n",int(x*10+.5)/10,pref[y],$6,$7,$9); sum += $5} END {print "Total:" sum/1024**3 " G" }';printf "\n\n"


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# P1: READABLE
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
printf "\n(\033[34mThis may take a while\033[0m)\n\n\n"; 
(find /home /var/log /var/lib/ 
	-regextype posix-extended
	-not -path "/home/virtfs/*" 
	-name "*log*" 
	-and 
	-not -regex ".*\.(MY[DI]|ibd)" 
	-type f 
	-size +200M 
	-exec ls -sh '{}' \; 
	| awk '{printf "%6s\t%s\n",$1,$(NF)}') 
	| sort -rn;
	printf "\n\n"
	
### v1.2 ###	
# printf "\n(\033[34mThis may take a while\033[0m)\n\n\n"; 
# (find /home /var/log /var/lib/ 
# 	-name "*log*" 
# 	-and 
# 	-not -name "*.ibd" 
# 	-not -path "/home/virtfs/*" 
# 	-type f 
# 	-size +200M 
# 	-exec ls -sh '{}' \; 
# 	| awk '{printf "%6s\t%s\n",$1,$(NF)}') 
# 	| sort -rn;
# 	printf "\n\n"
