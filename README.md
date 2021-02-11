# checkmk-haproxy-localcheck

a localcheck to monitore haproxy 

place here  /usr/lib/check_mk_agent/local 

restart check_mk_agent

do an service discover in WATO

sure you have to enable the status page on haproxy first ;)

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