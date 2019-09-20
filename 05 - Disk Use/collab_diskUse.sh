#!/bin/bash
function digging()
{
    count=$2

    dir=$(du -xh --exclude={'/run/*','/backup/*','/proc/*'} --max-depth=1 $1 2>/dev/null | awk '$1 ~ /G/{print}' |sort -rnk1)

    if [ $count -eq 2 ]; then
        printf "\n"
    fi

    if [ $count -eq 4 ] && [ "$(echo $dir | grep home)" ]; then
		printf "\n"
		for(( i=1;i<=count;i++))
			do
				printf " "
			done
        printf "────────────────────\n"
		for(( i=1;i<=count;i++))
		    do
		        printf " "
		    done
	else
		for(( i=1;i<=count;i++))
		do
			printf " "
		done
    fi

    printf "└╼$(echo "$dir" | egrep $1$ | awk -F '/' '{print $NF" \t[ "$1" ]"}')\n"

	if [ $count -eq 4 ] && [ "$(echo $dir | grep home)" ]; then
		for(( i=1;i<=count;i++))
		    do
		        printf " "
		    done
        printf "────────────────────\n"
    fi

    if [ "$dir" ]; then
        count=$((count+2))
        for i in $(echo "$dir" | awk '{print $2}' | egrep -v ^$1$)
	        do
	            digging $i $count
	        done
        count=$2
    fi
}

digging / 0



##############################################################################################################################
# Original
##############################################################################################################################
# function digging()
# {
#     count=$2
# 
#     dir=$(du --exclude={'/run/*','/backup/*','/proc/*'} --max-depth=1 $1 2>/dev/null | awk '$1 > (1024*1000) {gb = $1 /1024/1024; print gb"G "$2}' | sort -rnk 1)
# 
#     if [ $count -eq 2 ]; then
#         printf "\n"
#     fi
# 
#     if [ $count -eq 4 ] && [ "$(echo $dir | grep home)" ]; then
# 		printf "\n"
# 		for(( i=1;i<=count;i++))
# 			do
# 				printf " "
# 			done
#         printf "────────────────────\n"
# 		for(( i=1;i<=count;i++))
# 		    do
# 		        printf " "
# 		    done
# 	else
# 		for(( i=1;i<=count;i++))
# 		do
# 			printf " "
# 		done
#     fi
# 
#     printf "└╼$(echo "$dir" | egrep $1$ | awk -F '/' '{print $NF" \t[ "$1" ]"}')\n"
# 
# 	if [ $count -eq 4 ] && [ "$(echo $dir | grep home)" ]; then
# 		for(( i=1;i<=count;i++))
# 		    do
# 		        printf " "
# 		    done
#         printf "────────────────────\n"
#     fi
# 
#     if [ "$dir" ]; then
#         count=$((count+2))
#         for i in $(echo "$dir" | awk '{print $2}' | egrep -v ^$1$)
# 	        do
# 	            digging $i $count
# 	        done
#         count=$2
#     fi
# }
# 
# digging / 0
