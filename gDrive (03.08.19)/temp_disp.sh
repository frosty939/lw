#!/bin/bash

#timeout 5 curl --silent 'http://10.30.0.114/map/sse.php' > temperatures

list=$(egrep 's[0-9]' temperatures | grep tempAvg | cut -d: -f2,4 | sed -e 's/[\"}{,]//g' -e 's/[:]/ /' -e 's/b3//g' | sort -k2 -r)

for i in {2..9}; do 
    echo $list | sed 's/ /\n/g' | egrep '^s$i'
done
