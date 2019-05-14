#!/bin/bash

csfAllow="/etc/csf/csf.allow";
if egrep "^10.20.9.0\/24$|^10.30.9.0\/24$|^10.40.11.0\/28$|^10.41.9.0\/24$|^10.50.9.0\/24$" $csfAllow; then
	echo "everything exists. no need to add it"
else	
	printf "\nThey dont all exist. adding them\n"
	printf "Removing any existing rule for entire range (excluding port specific things)\n\n"
	printf "Backup of original file located at [$csfAllow.$(date +%Y%m%d)]"
	sed -E -i.lwbak$(date +%Y%m%d) '/^10.20.9.0\/24$|^10.30.9.0\/24$|^10.40.11.0\/28$|^10.41.9.0\/24$|^10.50.9.0\/24$/d' "$csfAllow"
	
	cat <<- 'EOF' >> "$csfAllow"
	####################################
	### LIQUID WEB MONITORING RANGES ###
	####################################
	10.20.9.0/24
	10.30.9.0/24
	10.40.11.0/28
	10.41.9.0/24
	10.50.9.0/24
	
	EOF
	
	printf "\n\n\e[0;33mThis is what the \e[0m[/etc/csf/csf.allow] \e[0;33mfile ends with now\e[;0m\n\n$(tail -9 $csfAllow)\n"
fi
csf -ra
