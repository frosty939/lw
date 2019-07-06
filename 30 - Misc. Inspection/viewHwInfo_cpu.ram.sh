(
clear
gap="$(printf %40s |tr " " "=")";
gapTitle="$(printf %10s |tr " " "-")";
function title { 
	printf "%s""\n$gap\n$gapTitle ${1}\n$gap\n";
};
title "CPU";
lscpu | awk -F: '/Thread|ocket/{printf "%20s:  %d\n",$1,$(NF-0)}';
printf "%20s:  %d\n" "TOTAL CORES" $(nproc);
title "RAM";
echo "Swappiness:    "$(cat /proc/sys/vm/swappiness);
free -h 2> /dev/null || free -m ;\
)



(clear;gap="$(printf %40s |tr " " "=")";gapTitle="$(printf %10s |tr " " "-")";function title { printf "%s""\n$gap\n$gapTitle ${1}\n$gap\n";};title "CPU";lscpu | awk -F: '/Thread|ocket/{printf "%20s:  %d\n",$1,$(NF-0)}';printf "%20s:  %d\n" "TOTAL CORES" $(nproc);title "RAM";echo "Swappiness:    "$(cat /proc/sys/vm/swappiness);free -h 2> /dev/null || free -m)
