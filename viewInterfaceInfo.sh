





awk '(f==0) { i=1; while ( i<=NF) {n[i] = $i; i++ }; f=1; next} (f==1){ i=2; while ( i<=NF){ printf "%s = %d\n", n[i], $i; i++}; f=0}'  /proc/net/netstat


#useful is netstat -s   fails/isn't avail
