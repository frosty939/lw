




# One-liner			  
printf "\n(\033[34mThis may take a  while\033[0m)\n\n";find / -not -path "/home/virtfs/*" -not -path "/proc/*" -not -path "/run/*" -not -path "/backup*/*" -not -name "*tmpDSK*" -type f -size +200M -exec ls -la '{}' \;  | awk 'BEGIN{pref[1]="K";pref[2]="M";pref[3]="\033[33mG\033[0m";pref[4]="T"} {x = $5; y = 0; while( x > 1024 ) { x = x/1024; y++; } printf("%6g%s\t %s\n",int(x*10+.5)/10,pref[y],$9); sum += $5} END {print "Total:" sum/1024**3 " G"  }';printf "\n\n"
			  
			  
			  
###############################################################################
# Original
###############################################################################
printf "\n\n";find / -not -path "/home/virtfs/*" -not -path "/proc/*" -not -path "/run/*" -not -path "/backup*/*" -not -name "*tmpDSK*" -type f -size +200M -exec ls -la '{}' \;  | awk 'BEGIN{pref[1]="K";pref[2]="M";pref[3]="G";pref[4]="T"} {x = $5; y = 0; while( x > 1024 ) { x = x/1024; y++; } printf("%g%s\t%s %s %s\n",int(x*10+.5)/10,pref[y],$6,$7,$9); sum += $5} END {print "Total:" sum/1024**3 " G"  }';printf "\n\n"
