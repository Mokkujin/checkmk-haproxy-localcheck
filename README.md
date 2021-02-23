# checkmk-haproxy-localcheck

## TL;DR

1. place here  /usr/lib/check_mk_agent/local 
2. wait or restart the check_mk_agent
3. do an service discover in WATO

---
## requirements

**check_haproxy.py** .. for sure needs **python3** :smirk:

**check_haproxy_py2.py** .. use python2 for those people who obviously dont updated to the last stable version is an unsupported and untested version for the no longer supported Python 2.x branch. Use at your own risk.

**check_haproxy.ps1** .. developed on powershell core for linux

**haproxy_checkmk.sh** .. developed on an bash 4 machine 

## choose your version and install

* its recommended to use the python version
* copy the file **check_haproxy.py** to **/usr/lib/check_mk_agent/local/**
* wait or restart the check_mk_agent
* do an **full scan** on the configured host in WATO

---

## info

a localcheck to monitore haproxy

bash is slower then python but if you are on an old system you could use bash as well
last but not least i created the same job an powershell version Why :wink: ? Because i can :smirk:

---

## sure you have to enable the status page on haproxy first

for example:
```bash
listen status
    bind *:9090
    mode http
    stats enable
    stats uri /haproxy
    acl localhost  src  127.0.0.1
    acl stats      path_beg  /haproxy
    http-request allow if stats localhost
    http-request deny  if stats !localhost
```

Contributor : [@jhochwald](https://github.com/jhochwald)
