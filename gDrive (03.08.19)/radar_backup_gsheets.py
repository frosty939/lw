# importing the requests library
import csv
import time
import gspread
import re
import sys
from oauth2client.service_account import ServiceAccountCredentials

nagios_stat_file = sys.argv[1]
google_worksheet_name = "/backup"
google_workbook_name = "/boot Alert Tickets"

scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']

credentials = ServiceAccountCredentials.from_json_keyfile_name("creds.json", scope)

gc = gspread.authorize(credentials)

wks = gc.open(google_workbook_name)
sps = wks.worksheet(google_worksheet_name)

stats={}
adding_notes = False
complete = False
row_pos=2
api_calls = 0
time_start = round(time.time())

# creating a dictionary with the actor and nagio stats info
with open(nagios_stat_file) as fp:
    for line in fp.readlines():
        if ( not adding_notes ):
            line = line.replace("\n","")
        if (re.search("Account:",line) and len(stats) == 0 ):
            stats['account']=line[line.find(":")+2:]
        if (re.search("UID:",line) and len(stats) == 1):
            stats['uid']=line[line.find(":")+2:]
        if (re.search("Priority:",line)and len(stats) == 2):
            stats['priority']=line[line.find(":")+2:]
        if (re.search("Host:",line) and len(stats) == 3):
            stats['host']=line[line.find(":")+2:]
        if (re.search("IP:",line) and len(stats) == 4):
            stats['ip']=line[line.find(":")+2:]

        if ( re.search("-- Notes --",line) or re.search("Bad Root Pass",line) ):
            adding_notes = True
            stats['notes'] = "=" + line 

        if ((adding_notes ) ):
            stats['notes'] += line

        if ( re.search("Radar Notes",line) != None):
            col_pos=1
            for info in stats:
                sps.update_cell(row_pos,col_pos,str(stats[info]))
                col_pos += 1
                #if ( info == "uid"):
                #    print (stats[info])
                stats[info]=""
                time.sleep(1)
                
            stats.clear()
            row_pos += 1

            adding_notes = False
            
    col_pos=1
    for info in stats:
        sps.update_cell(row_pos,col_pos,str(stats[info]))
        col_pos += 1
        time.sleep(1)