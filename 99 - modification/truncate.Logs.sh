#!/bin/bash 
#=======================================================================================
#=== DESCIPTION ========================================================================
#=======================================================================================
	## truncates files
	## 
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# selection for "keep the last 1k"	||	"keep the first 1k"	|| "custom range"
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


#### PART 1 ############################
	read -p "Log Path: " filePath;
	lengthFull="$(cat ${filePath} | wc -l )"

	sed -i.
