time find /root/loadwatch/ /var/log/loadwatch/ -name "*$(date +%Y-%m-%d)*" -exec egrep -m1 "^top.+load average" {} \;

real 0m0.522s		real 0m0.672s	real 0m0.734s	real 0m0.650s
user 0m0.184s		user 0m0.214s	user 0m0.233s	user 0m0.211s
 sys 0m0.338s		sys	 0m0.330s	 sys 0m0.382s	sys	 0m0.349s
 

-----------------------------------
time find /root/loadwatch/ /var/log/loadwatch/ -name "*$(date +%Y-%m-%d)*" -exec awk '/^top.+load average/{print $0}' {} \;

real	0m0.388s	real 0m0.511s	real	0m0.476s	real	0m0.337s
user	0m0.177s	user 0m0.187s	user	0m0.198s	user	0m0.167s
sys	0m0.194s		sys  0m0.181s	sys	0m0.191s		sys	0m0.171s

-----------------------------------

time find /root/loadwatch/ /var/log/loadwatch/ -name "*$(date +%Y-%m-%d)*" -exec awk '/^top.+load average/{print FILENAME,$(NF-2),$(NF-1),$(NF-0)}' {} \;

real	0m0.341s	real	0m0.636s	real	0m0.617s	real	0m0.380s
user	0m0.180s	user	0m0.244s	user	0m0.236s	user	0m0.187s
 sys	0m0.163s	 sys	0m0.248s	 sys	0m0.272s	 sys	0m0.193s

-----------------------------------
time find /root/loadwatch/ /var/log/loadwatch/ -name "*$(date +%Y-%m-%d)*" -exec awk '/^top.+load average/{print FILENAME,$(NF-2),$(NF-1),$(NF-0);exit;}' {} \; |column -t
#if it fails, remove the `;exit;` part
-----------------------------------

awk -v cores="$(nproc)" -v red="$(tput setaf 1)" -v "$(tput setaf 3)" -v reset="$(tput sgr0)" \
'{
	printf "%s"OFS, $1
	if ($(NF-2) > $cores) {
		printf "%s", red
	} else if ($(NF-1) > $cores/2) {
		prinf "%s", yellow
	}
	printf "%s%s\n", $3, reset
}'











 
