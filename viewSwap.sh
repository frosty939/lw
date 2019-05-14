#!/bin/bash
#https://stackoverflow.com/questions/479953/how-to-find-out-which-processes-are-using-swap-space-in-linux
# Get current swap usage for all running processes
# Erik Ljungstrom 27/05/2011
# Modified by Mikko Rantalainen 2012-08-09
# Pipe the output to "sort -nk3" to get sorted output
# Modified by Marc Methot 2014-09-18
# removed the need for sudo

SUM=0
OVERALL=0
for DIR in `find /proc/ -maxdepth 1 -type d -regex "^/proc/[0-9]+"`
do
    PID=`echo $DIR | cut -d / -f 3`
    PROGNAME=`ps -p $PID -o comm --no-headers`
    for SWAP in `grep VmSwap $DIR/status 2>/dev/null | awk '{ print $2 }'`
	    do
	        let SUM=$SUM+$SWAP
	    done
    if (( $SUM > 0 )); then
        echo "PID=$PID swapped $SUM KB ($PROGNAME)"
    fi
    let OVERALL=$OVERALL+$SUM
    SUM=0
done
echo "Overall swap used: $OVERALL KB"



#######
### faster version
#(can be faster, and better.. fix it..)
#for file in /proc/*/status ; do awk '/Tgid|VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | grep kB | sort -k 3 -n
### one-line copy/pastable
#(for file in /proc/*/status ; do awk '/Tgid|VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | grep kB | sort -k 3 -n)
#
#
#


(for file in /proc/*/status ; do
	 awk '/Tgid|VmSwap|Name/{printf ("%-20s%-10s",$2,$3)}END{ print ""}' $file;
 done | grep kB | sort -k 3 -n)


 (for file in /proc/*/status ; do
 	 awk '/Tgid|VmSwap|Name/{printf ("\n%-20s%-5s%s",$2,$3,$4,$5)}' $file;
  done | grep kB | sort -k 3 -n)

(for file in /proc/*/status ; do
	awk '{printf "\n"$0}END{ print ""}' $file;
done | grep kB | sort -k 3 -n)


awk '/Tgid|VmSwap|Name/{printf ("%20s%s",$2,$3)}END{print ""}' /proc/3877/status
