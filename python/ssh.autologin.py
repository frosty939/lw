#!/usr/bin/env python3
###
# example code for billing API calls
###
# importing the requests library
import requests
import getpass
import json
import urllib3

print ("\nBILLING LOGIN INFORMATION\n")

USER = input('Username: ')
with open('/home/wayne/.passwords/billing', 'r') as file:
	PASS	=	file.read().replace('\n', '')
UID = input('\nUID: ')

# api-endpoint
URL = "https://api.int.liquidweb.com/bleed/Billing/Subaccnt/details"

# sending get request and saving the response as response object
r = requests.post(url=URL,auth=(USER,PASS),json={"params":{"uniq_id":UID}})

#print (r)
if (r.status_code == 200):
    output = json.loads(r.text)
    print (output)
else:
    print("Invalid Login Information.")
