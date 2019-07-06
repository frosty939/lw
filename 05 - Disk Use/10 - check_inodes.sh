#!/bin/bash


### One-liner ###
df -hi |awk '/%/{if($5+0 >= 100)$5="\033[31m"$5"\033[0m";else if($5+0 >= 70)$5="\033[33m"$5"\033[0m";else if($5+0 < 70)$5="\033[32m"$5"\033[0m";print}'|sed 's/on//'|column -t



### Readable ###

df -hi |awk '{
	/%/
	if($5+0 < 70)
		$5="\033[32m"$5"\033[0m";
	else if($5+0 >= 70)
		$5="\033[33m"$5"\033[0m";
	else if($5+0 >= 100)$5="\033[32m"$5"\033[0m";
	print
	}'|sed 's/on//'|column -t
