#!/usr/bin/python3
import time
import sys

from selenium								import webdriver

profile = webdriver.FirefoxProfile("./firefox_profiles/selenium")
driver = webdriver.Firefox(firefox_profile=profile)
driver.get("http://whatismyip.com")
