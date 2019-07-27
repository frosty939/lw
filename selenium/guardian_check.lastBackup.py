#!/usr/bin/python3
#=======================================================================================
#=== DESCIPTION ========================================================================
# Original by: dnemcik
#=======================================================================================
	## Checks for most recent successful back, or most recent backup failure
	## ARG1	=	BM
	## ARG2	=	Target IP
#=======================================================================================
#=======================================================================================
	#
	#*************** NEED TO DO/ADD ***********************
	# 
	#******************************************************
	#
#///////////////////////////////////////////////////////////////////////////////////////
#|||||||||||||||||||||||| Script Stuff Starts |||||||||||||||||||||||||||||||||||||||||
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

### Import all of the things ###
import time
import sys
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from datetime import datetime, timedelta

### Pulls admin username and password ###
with open('/home/wayne/.passwords/bm_admin','r') as file:
	password	=	file.read().replace('\n','')
username = "admin"

### Sets variables ###
expandVar = 0
alertPull = 0
pageCount = 1
testLoop = None
lastSucTime=datetime(2000, 1, 1)
lastFailTime=datetime(2000, 1, 1)

BM = sys.argv[1]
IP = sys.argv[2]

### Start FireFox and go to backup manager ###
options = Options()
options.headless = True
## Just trying to get to step 1...
firefox_profile = webdriver.FirefoxProfile()
firefox_profile.set_preference("browser.privatebrowsing.autostart", True)

driver = webdriver.Firefox(firefox_profile=firefox_profile)

## GUI
# driver = webdriver.Firefox()
## Headless
# driver = webdriver.Firefox(options=options, executable_path=r'/usr/bin/geckodriver')

driver.implicitly_wait(15)
driver.get("https://" + BM + "/Agent")

### Selects the Local User type ###
#(probably not needed anymore since it was removed?)
# if (driver.find_elements_by_class_name("z-combobox-icon.z-icon-caret-down")[1].is_displayed() == "True"):
#     driver.find_elements_by_class_name("z-combobox-icon.z-icon-caret-down")[1].click()
#     driver.find_elements_by_class_name("z-comboitem-text")[1].click()

#Enter username and password
elem = driver.find_element_by_name("j_username")
elem.clear()
elem.send_keys(username)
elem = driver.find_element_by_name("j_password")
elem.clear()
elem.send_keys(password)

#Loops until the Advanced Filter is clickable
while testLoop is None:
    try:
        testLoop = WebDriverWait(driver,300).until(EC.element_to_be_clickable((By.XPATH, "//*[contains(text(), 'Advanced Filter')]")))
    except:
        pass

#Clicks the Advanced Filter and the Host Name/IP checkbox
testLoop.click()
WebDriverWait(driver,300).until(EC.element_to_be_clickable((By.XPATH, "//*[contains(text(), 'Host Name/IP')]"))).click()

#Waits until the drop down is modifiyible
while (driver.find_elements_by_xpath("//input[@value='Starts With']")[1].is_enabled() == 0):
    time.sleep(.25)

#Sets the drop down to Ends with
driver.find_elements_by_xpath("//input[@value='Starts With']")[1].click()
driver.find_elements_by_class_name("z-comboitem-text")[2].click()

#Enters the IP address into the textbox
elem = driver.find_elements_by_class_name("z-textbox")[1]
elem.send_keys(IP)

#Clicks the Filter button
driver.find_elements_by_xpath("//*[contains(text(), 'Filter')]")[3].click()

#Waiting until there is 1 or 0 Protected Machine left
while not (len(driver.find_elements_by_xpath("//tbody/tr/td/div/span")) <= 4):
    time.sleep(.25)

#Checks to see if there are no Protected Machines then there is likely an orphaned policy/volume
if (len(driver.find_elements_by_xpath("//tbody/tr/td/div/span")) == 0):
    print("No protected machine with the description of " + IP)
    sys.exit()

#Pulls the UID and the on disk size, for filtering and to give to the user
UID = driver.find_elements_by_xpath("//tbody/tr/td/div/span[@class='z-label']")[0].text
print("Server UUID: " + UID)
SIZE = driver.find_elements_by_xpath("//tbody/tr/td/div/span[@class='z-label']")[1].text

#Clicks the cog icon and the clicks into Task History
driver.find_element_by_class_name("fa.fa-cog.fa-lg").click()
driver.find_element_by_xpath("//*[contains(text(), 'Task History')]").click()

#Keeps advancing the pages until it finds either a failure or a success on a backup process
while (len(driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Finished' or @title='Error']/../../..")) == 0):
    pageCount = pageCount + 1
    driver.find_elements_by_xpath("//a[text()=%s]" % pageCount)[-1].click()
    while (len(driver.find_elements_by_xpath("//a[text()=%s]/..[@class=' active']" % pageCount)) != 1):
        time.sleep(.25)

#Attempts to set the Success and Failure times to what is in the backup manager
try:
    lastFailTime=driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Error']/../../../td/div/span[contains(text(), ' AM') or contains(text(), ' PM')]")[0].text
    lastFailTime=datetime.strptime(lastFailTime, '%d-%b-%y %I:%M %p')
except:
    print("No last failure on this page")

try:
    lastSucTime=driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Finished']/../../../td/div/span[contains(text(), 'AM') or contains(text(), 'PM')]")[0].text
    lastSucTime=datetime.strptime(lastSucTime, '%d-%b-%y %I:%M %p')
except:
    print("No last success on this page")

#Compares the numbers and if the failed is more recent then it checks the alerts
if (lastSucTime < lastFailTime):
    driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Error']/../../../td/div/div/i[@class='z-detail-icon z-icon-angle-right']")[0].click()
    driver.find_element_by_xpath("//*[contains(text(), 'Alerts')]").click()
    elem = driver.find_elements_by_xpath("//div/div/div/div/div/table/tbody/tr/th/div[contains(text(), 'Alert Time')]/../../../../../../../../../div/div/div/div/table/tbody/tr/td/div/div/i[@class='z-detail-icon z-icon-angle-right']")
    for i in range(len(elem)):
        elem[i].click()
    elem = driver.find_elements_by_xpath("//td/div/span[@class='z-label']")
    for i in range(len(elem)):
        if not ("" == elem[i].text or "Manager" == elem[i].text or UID == elem[i].text or UID + " (Complex)" == elem[i].text or SIZE == elem[i].text):
            print(elem[i].text)
else:
    #If the most recent success is more recent than the failure then it checks to see if the success has alerts
    if (len(driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Finished']/../../../td/div/a/i[@class='r1-warning-yellow z-icon-exclamation-triangle z-icon-lg']")) == 0):
        print("Last completed backup was successful")
    else:
        driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Finished']/../../../td/div/a/i[@class='r1-warning-yellow z-icon-exclamation-triangle z-icon-lg']/../../../../td/div/div/i[@class='z-detail-icon z-icon-angle-right']")[0].click()
        driver.find_element_by_xpath("//*[contains(text(), 'Alerts')]").click()
        elem = driver.find_elements_by_xpath("//div/div/div/div/div/table/tbody/tr/th/div[contains(text(), 'Alert Time')]/../../../../../../../../../div/div/div/div/table/tbody/tr/td/div/div/i[@class='z-detail-icon z-icon-angle-right']")
        for i in range(len(elem)):
            elem[i].click()
        elem = driver.find_elements_by_xpath("//td/div/span[@class='z-label']")
        for i in range(len(elem)):
            if not ("" == elem[i].text or "Manager" == elem[i].text or UID == elem[i].text or UID + " (Complex)" == elem[i].text or SIZE == elem[i].text):
                print(elem[i].text)

#Closes out of the window
driver.close()



















#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++ ORIGINAL ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# #Import all of the things
# import time
# import sys
# from selenium import webdriver
# from selenium.webdriver.common.keys import Keys
# from selenium.webdriver.support.ui import WebDriverWait
# from selenium.webdriver.support import expected_conditions as EC
# from selenium.webdriver.common.by import By
# from selenium.webdriver.firefox.options import Options
# from datetime import datetime, timedelta
# 
# #Pulls admin username and password
# f=open("/home/dnemcik/scripts/Guardian/6pass.txt","r")
# lines=f.readlines()
# password=lines[0]
# f.close()
# username = "admin"
# 
# #Sets variables
# expandVar = 0
# alertPull = 0
# pageCount = 1
# testLoop = None
# lastSucTime=datetime(2000, 1, 1)
# lastFailTime=datetime(2000, 1, 1)
# 
# BM = sys.argv[1]
# IP = sys.argv[2]
# 
# #Start FireFox and go to backup manager
# options = Options()
# options.headless = True
# #driver = webdriver.Firefox()
# driver = webdriver.Firefox(options=options, executable_path=r'/usr/bin/geckodriver')
# driver.implicitly_wait(15)
# driver.get("https://" + BM + "/Agent")
# 
# #Selects the Local User type
# if (driver.find_elements_by_class_name("z-combobox-icon.z-icon-caret-down")[1].is_displayed() == "True"):
#     driver.find_elements_by_class_name("z-combobox-icon.z-icon-caret-down")[1].click()
#     driver.find_elements_by_class_name("z-comboitem-text")[1].click()
# 
# #Enter username and password
# elem = driver.find_element_by_name("j_username")
# elem.clear()
# elem.send_keys(username)
# elem = driver.find_element_by_name("j_password")
# elem.clear()
# elem.send_keys(password)
# 
# #Loops until the Advanced Filter is clickable
# while testLoop is None:
#     try:
#         testLoop = WebDriverWait(driver,300).until(EC.element_to_be_clickable((By.XPATH, "//*[contains(text(), 'Advanced Filter')]")))
#     except:
#         pass
# 
# #Clicks the Advanced Filter and the Host Name/IP checkbox
# testLoop.click()
# WebDriverWait(driver,300).until(EC.element_to_be_clickable((By.XPATH, "//*[contains(text(), 'Host Name/IP')]"))).click()
# 
# #Waits until the drop down is modifiyible
# while (driver.find_elements_by_xpath("//input[@value='Starts With']")[1].is_enabled() == 0):
#     time.sleep(.25)
# 
# #Sets the drop down to Ends with
# driver.find_elements_by_xpath("//input[@value='Starts With']")[1].click()
# driver.find_elements_by_class_name("z-comboitem-text")[2].click()
# 
# #Enters the IP address into the textbox
# elem = driver.find_elements_by_class_name("z-textbox")[1]
# elem.send_keys(IP)
# 
# #Clicks the Filter button
# driver.find_elements_by_xpath("//*[contains(text(), 'Filter')]")[3].click()
# 
# #Waiting until there is 1 or 0 Protected Machine left
# while not (len(driver.find_elements_by_xpath("//tbody/tr/td/div/span")) <= 4):
#     time.sleep(.25)
# 
# #Checks to see if there are no Protected Machines then there is likely an orphaned policy/volume
# if (len(driver.find_elements_by_xpath("//tbody/tr/td/div/span")) == 0):
#     print("No protected machine with the description of " + IP)
#     sys.exit()
# 
# #Pulls the UID and the on disk size, for filtering and to give to the user
# UID = driver.find_elements_by_xpath("//tbody/tr/td/div/span[@class='z-label']")[0].text
# print("Server UUID: " + UID)
# SIZE = driver.find_elements_by_xpath("//tbody/tr/td/div/span[@class='z-label']")[1].text
# 
# #Clicks the cog icon and the clicks into Task History
# driver.find_element_by_class_name("fa.fa-cog.fa-lg").click()
# driver.find_element_by_xpath("//*[contains(text(), 'Task History')]").click()
# 
# #Keeps advancing the pages until it finds either a failure or a success on a backup process
# while (len(driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Finished' or @title='Error']/../../..")) == 0):
#     pageCount = pageCount + 1
#     driver.find_elements_by_xpath("//a[text()=%s]" % pageCount)[-1].click()
#     while (len(driver.find_elements_by_xpath("//a[text()=%s]/..[@class=' active']" % pageCount)) != 1):
#         time.sleep(.25)
# 
# #Attempts to set the Success and Failure times to what is in the backup manager
# try:
#     lastFailTime=driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Error']/../../../td/div/span[contains(text(), ' AM') or contains(text(), ' PM')]")[0].text
#     lastFailTime=datetime.strptime(lastFailTime, '%d-%b-%y %I:%M %p')
# except:
#     print("No last failure on this page")
# 
# try:
#     lastSucTime=driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Finished']/../../../td/div/span[contains(text(), 'AM') or contains(text(), 'PM')]")[0].text
#     lastSucTime=datetime.strptime(lastSucTime, '%d-%b-%y %I:%M %p')
# except:
#     print("No last success on this page")
# 
# #Compares the numbers and if the failed is more recent then it checks the alerts
# if (lastSucTime < lastFailTime):
#     driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Error']/../../../td/div/div/i[@class='z-detail-icon z-icon-angle-right']")[0].click()
#     driver.find_element_by_xpath("//*[contains(text(), 'Alerts')]").click()
#     elem = driver.find_elements_by_xpath("//div/div/div/div/div/table/tbody/tr/th/div[contains(text(), 'Alert Time')]/../../../../../../../../../div/div/div/div/table/tbody/tr/td/div/div/i[@class='z-detail-icon z-icon-angle-right']")
#     for i in range(len(elem)):
#         elem[i].click()
#     elem = driver.find_elements_by_xpath("//td/div/span[@class='z-label']")
#     for i in range(len(elem)):
#         if not ("" == elem[i].text or "Manager" == elem[i].text or UID == elem[i].text or UID + " (Complex)" == elem[i].text or SIZE == elem[i].text):
#             print(elem[i].text)
# else:
#     #If the most recent success is more recent than the failure then it checks to see if the success has alerts
#     if (len(driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Finished']/../../../td/div/a/i[@class='r1-warning-yellow z-icon-exclamation-triangle z-icon-lg']")) == 0):
#         print("Last completed backup was successful")
#     else:
#         driver.find_elements_by_xpath("//table/tbody/tr/td/div/span[text()='Backup']/../../../td/div/a[@title='Finished']/../../../td/div/a/i[@class='r1-warning-yellow z-icon-exclamation-triangle z-icon-lg']/../../../../td/div/div/i[@class='z-detail-icon z-icon-angle-right']")[0].click()
#         driver.find_element_by_xpath("//*[contains(text(), 'Alerts')]").click()
#         elem = driver.find_elements_by_xpath("//div/div/div/div/div/table/tbody/tr/th/div[contains(text(), 'Alert Time')]/../../../../../../../../../div/div/div/div/table/tbody/tr/td/div/div/i[@class='z-detail-icon z-icon-angle-right']")
#         for i in range(len(elem)):
#             elem[i].click()
#         elem = driver.find_elements_by_xpath("//td/div/span[@class='z-label']")
#         for i in range(len(elem)):
#             if not ("" == elem[i].text or "Manager" == elem[i].text or UID == elem[i].text or UID + " (Complex)" == elem[i].text or SIZE == elem[i].text):
#                 print(elem[i].text)
# 
# #Closes out of the window
# driver.close()
