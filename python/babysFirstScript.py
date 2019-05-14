#!/usr/bin/env python3
#################################################
#  https://automatetheboringstuff.com/chapter0/
#  
#  
# 
 

#============
# 
#============
#################################################

#============
# variable checking
#============
USER = "wboyer"
#PASS = open('/home/wayne/.passwords/billing','r')

with open('/home/wayne/.passwords/billing', 'r') as file:
	PASS	=	file.read().replace('\n', '')

print (USER)
print (PASS)



#============
# pw checking from pt file
#============
#passwordFile = open('/home/wayne/.passwords/billing')
#secretPassword = passwordFile.read()
#
#print('Enter pw: ')
#typedPassword = input()
#
#if typedPassword == secretPassword:
#	print('granted')
#if typedPassword == '123':
#	print('yousuck.lol')
#else:
#	print('nou')
#
