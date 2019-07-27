#!/bin/bash
userName="$(cat $HOME/.passwords/billing.userName)"
password="$(cat $HOME/.passwords/billing)"
#uidGrab="FLW8V6"
#accntGrab="309431"


curl -u ${userName}:${password} \
	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/Auth/details' \
	--data '{"params":{"uniq_id":"FLW8V6"}}'

#curl -u ${userName}:${password} \
##	--silent 'https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details' \
#	--silent 'https://api.int.liquidweb.com/bleed/Asset/Monitoring/status' \
##	 --data '{"params":{"uniq_id":"FLW8V6"}}' | jq -r '.accnt' \
#	 --data '{"params":{"accnt":"309431"}}' | jq -r '.accnt'

