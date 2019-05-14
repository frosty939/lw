#!/usr/bin/env python3

#######################
##Creator: DMcDermitt##
#######################

# importing the requests library
import requests
import getpass
import json

print ("\nBILLING LOGIN INFORMATION\n")

USER = input('Username: ')
#PASS = input()
PASS = getpass.getpass()
UID = input('\nUID: ')

# api-endpoint
URL = "https://api.int.liquidweb.com/bleed/Provisioning/Backup/list"

# sending get request and saving the response as response object
r = requests.post(url=URL,auth=(USER,PASS),json={"params":{"uniq_id":UID}})

#print (r)
if (r.status_code == 200):
    output = json.loads(r.text)
    if ( output['item_count'] > 0 ):
        print ( "Account: " + str(output['items'][0]['accnt']) )
        print ( "Backups Found: " + str(output['item_count']) + '\n' )
        for i in output['items']:
            print ( i['display_name'] )
    else:
        print ("No Backups")
else:
    print("Invalid Login Information.")
