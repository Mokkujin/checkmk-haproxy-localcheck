#!/bin/env python3
import requests
import csv
# disable ssl warning
import urllib3
urllib3.disable_warnings()
# define vars
url = 'https://localhost/lbstatistik;csv'
auth_u = 'user'
auth_p = 'pass'
# define thresholds
warn = 0.85
crit = 0.90
# do check
r = requests.get(url , verify=False , auth=(auth_u,auth_p))
content = r.content
out = content.splitlines()
for entry in out:
    line = entry.decode("utf-8")
    if line.startswith('#'):
        continue
    linearr = line.split(',')
    str_host = linearr[0]
    str_conf = linearr[1]
    str_onli = linearr[17]
    s_cur = linearr[4]
    s_max = linearr[5]
    # calc thresholds
    s_warn = round(int(s_max) * warn)
    s_crit = round(int(s_max) * crit)
    if str_onli == "UP" or str_onli == "OPEN":
        if int(s_cur) < s_warn and int(s_cur) < s_crit:
            status = "0"
        if int(s_cur) >= s_warn:
            status = "1"
        if int(s_cur) >= s_crit:
            status = "2"
        if int(s_max) == 0 or int(s_cur) == 0:
            status = "0"
    else:
        status = "2"
    print("{0} {1}-{2} - {3} {4}/{5} Sessions Host is {6}".format(status,str_host,str_conf,str_conf,s_cur,s_max,str_onli)) 