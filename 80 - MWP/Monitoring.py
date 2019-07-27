#!/usr/bin/env python2
#=======================================================================================
#=== DESCIPTION ========================================================================
#= Original by: dnemcik?
#=======================================================================================
	## Pulls the alerting server info for MWP stuff
	## 
	## 
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# Cleanup output
	# Gather correct UID
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
import sys, os, time, json
import requests
###Removed as it is no longer necessary (due to line 23)
#import argparse
###

## Severities
# Uses zenoss scheme
# 5 Error Red
# 4 Warning Yellow
# 3 Notice Cyan?
# 2 Purl
# 1 Green

CACHE_DIR = '/home/support-tools/'

RESOURCES = {'mwp-nagios': {
                'interval': 30},
             'mwp-prometheus': {
                 'interval': 30},
            }

### Added a ignore list ###
ignores=["liquidweb.com", 
        "has been in Pending-Activation for"]
###

###Removed so that the ignore-nagios and cache_dir could be hardcoded
#parser = argparse.ArgumentParser()
#parser.add_argument('--ignore-nagios', dest="show_nagios", action='store_false')
#parser.add_argument('cache_dir', default=CACHE_DIR, action='store')
#args = parser.parse_args()
#
#if not args.show_nagios:
#    del RESOURCES['mwp-nagios']
del RESOURCES['mwp-nagios']
cache_dir = 'http://support-n01.wc1.lan3.stabletransit.com/monitor_wide.json'
####

PODS = list(reversed(sorted(RESOURCES.keys())))

os.system('stty -echo')

class termcolor:
        red = '\033[31m'
        green = '\033[38;05;46m'
        yellow = '\033[33m'
        blue = '\033[34m'
        purple = '\033[35m'
        cyan = '\033[36m'
        reset = '\033[0m'
        severity = [reset, green, purple, cyan, yellow, red]

def main(cache_dir=None):
    try:
        if 'http' in cache_dir:
           cache_location = cache_dir
           data_dict = requests.get(cache_location).json()
           presults(data_dict, cache_location)
        else:
           cache_location = cache_dir+'monitor_wide.json' if cache_dir else None
           with open(cache_location) as infile:
                data_dict = json.load(infile)
                presults(data_dict, cache_location)
    except:
        pass
    time.sleep(5)
    return True

def presults(data, cache_location):
    print "Date: {0} ---- Cache location: {1}".format(
            time.strftime("%Y-%m-%d %H:%M"), cache_location)
    for resource in PODS:
        if resource == 'queuesize':
            continue
        events = data[resource].get('events', None)
        ######Added by DNemcik to remove liquidweb.com from the array
        for ignore in ignores:
            i=0
            length = len(events)
            while(i<length):
                if(ignore in events[i]['event']):
                    events.remove (events[i])
                    length = length -1
                    continue
                i = i+1
        ######
        if not events:
            print "{0}[{1} ({invl}s)]{2} - {3}All checks report OK!{2}".format(
                    termcolor.blue, resource, termcolor.severity[0],
                    termcolor.severity[1], termcolor.severity[0],
                    invl=RESOURCES[resource]['interval'])
        else:
            for event in events:
                print "{0}[{1} ({invl}s)]{2} - {3}{4}{2}".format(
                       termcolor.blue, resource, termcolor.severity[0],
                       termcolor.severity[event['severity']], event['event'],
                       termcolor.severity[0],
                       invl=RESOURCES[resource]['interval'])
    return data

if __name__ == '__main__':
#    if len(sys.argv) > 1:
#        cache_dir = sys.argv[1]
#    else:
#        cache_dir = CACHE_DIR
    while True:
        try:
            os.system('clear')
            main(cache_dir)
#            main(args.cache_dir) ### Removed so that I can just pass the single argument
        except (KeyboardInterrupt, Exception) as e:
            print "Application crashed/closed fixing stty"
            print e
            os.system('stty echo')
            sys.exit(0)
