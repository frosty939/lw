(echo "Domain Docroot Robots";
while read domain user doc; do
	file="${doc}/robots.txt";
	echo -n "${domain} ";
	if [[ -d ${doc} ]]; then
		echo -n "EXISTS ";
		if [[ -f ${file} ]]; then
		 	if [[ -s ${file} ]]; then
				 echo "EXISTS";
			 else echo "APPENDED" && echo -e "User-agent: *\nCrawl-delay: 5" >> ${file};
			fi;
		else echo "CREATED" && touch ${file} && echo -e "User-agent: *\nCrawl-delay: 5" >> ${file} && chown ${user}:${user} ${file};
		fi;
	else
		echo "NO NO";
	fi;
done < <(sed -r "s/^(.*+)\: ([^=]+)=+[^=]+=+([^=]+)=+[^=]+=+([^=]+)=+.*$/\1 \2 \4/g" /etc/userdatadomains))|column -t
