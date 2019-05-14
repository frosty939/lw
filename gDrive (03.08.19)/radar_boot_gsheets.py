# importing the requests library
import csv
import time
import gspread
import re
import sys
from oauth2client.service_account import ServiceAccountCredentials

nagios_stat_file = sys.argv[1]
google_worksheet_name = "Sheet1"
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
        if (re.search("Account",line) != None):
            stats['account']=line[line.find(":")+2:]
        if (re.search("UID",line)!= None):
            stats['uid']=line[line.find(":")+2:]
        if (re.search("Priority",line)!= None):
            stats['priority']=line[line.find(":")+2:]
        if (re.search("Host",line)!= None):
            stats['host']=line[line.find(":")+2:]
        if (re.search("IP",line)!= None):
            stats['ip']=line[line.find(":")+2:]
        if ( re.search("Notes",line)!= None and not (re.search("Radar",line)!= None)):
            adding_notes = True
            stats['notes'] = "=" + line
        if ( re.search("Radar",line) != None):
            col_pos=1
            for info in stats:
                sps.update_cell(row_pos,col_pos,str(stats[info]))
                api_calls+=1
                col_pos += 1
                stats[info]=""
                time.sleep(1)

            row_pos += 1

            adding_notes = False
            
        if (adding_notes or re.search("Bad",line)):
            stats['notes'] += line
    for info in stats:
        sps.update_cell(row_pos,col_pos,str(stats[info]))
        col_pos += 1
        stats[info]=""
        time.sleep(1)