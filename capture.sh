/etc/init.d/networking force-reload
/etc/init.d/nscd restart
tshark -f "port 80 or  port 443 or port 4545 or port 53 or port 1194 or port 51194 and not (dst host 192.168.0.184 and dst port 80) and not (src host 192.168.0.184 and src port 80)" -P -w $1
