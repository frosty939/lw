#terrible.. fix this garbage
	find /var/log -name "*maillog*" -exec egrep "lmtp\(.*@.*unidataweb.*\)" {} \; |egrep -v "spamd" | cut -d" " -f6 |grep -v dovecot: |sort -u
	# output
		#lmtp(colonial@host4.unidataweb4.ca):
		#lmtp(ecsafety@host4.unidataweb4.ca):
		#lmtp(hanna@host4.unidataweb4.ca):
		#lmtp(nbao@host4.unidataweb4.ca):
		#lmtp(nbapc@host4.unidataweb4.ca):
		#lmtp(picaroon@host4.unidataweb4.ca):
		#lmtp(vanwart@host4.unidataweb4.ca):




# xdotool for grabbing server from mr radar

# command line monitoring of nagios/guard/alarms
	ssh -p2020 utilities.smr.liquidweb.com
# cli for raidalarm
	ssh -p2020 raidalarm.sysres.liquidweb.com


# find all instances of zend cache errors and the assoicated ips + number of hits
	grep zend /usr/local/apache/logs/error_log | cut -d] -f4 | awk '{print $2}' | cut -d: -f1 | sort -rn | uniq -c | sort -rn | head
