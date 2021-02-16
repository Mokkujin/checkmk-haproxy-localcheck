# checkmk-haproxy-localcheck

its recommended to use the python version

bash is slower then python but if you are on an old system you could use bash as well

a localcheck to monitore haproxy 

---

## Install it

1. place here  /usr/lib/check_mk_agent/local 

2. restart check_mk_agent

3. do an service discover in WATO

---

## sure you have to enable the status page on haproxy first ;)

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
