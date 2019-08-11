









###############################################################################
# v1.1 check home
###############################################################################
printf "\n\n";find /home /var/log /var/lib/ -name "*log*" -and -not -name "*.ibd" -not -path "/home/virtfs/*" -type f -size +200M -exec ls -ls '{}' \;  | awk '{printf "%6s\t%s\n",$1,$2}';printf "\n\n"

			  
			  
			  
###############################################################################
# ~Original
###############################################################################
printf "\n\n";find /home /var/log /var/lib/ -name "*log*" -and -not -name "*.ibd" -not -path "/home/virtfs/*" -type f -size +200M -exec ls -la '{}' \;  | awk 'BEGIN{pref[1]="K";pref[2]="M";pref[3]="G";pref[4]="T"} {x = $5; y = 0; while( x > 1024 ) { x = x/1024; y++; } printf("%g%s\t%s %s %s\n",int(x*10+.5)/10,pref[y],$6,$7,$9); sum += $5} END {print "Total:" sum/1024**3 " G"  }';printf "\n\n"
