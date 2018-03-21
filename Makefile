timestr:=$(shell date +"%y%m%d_%H%M%S")

dns_not_pollution:
	bash capture.sh $@.$(timestr).pcapng </dev/null &
	sleep 2
	-dig www.baidu.com @13.75.126.142> $@.$(timestr).log 2>&1
	sleep 2
	killall tshark
	
dns_pollution:
	bash capture.sh $@.$(timestr).pcapng </dev/null &
	sleep 2
	-dig www.google.com @13.75.126.142> $@.$(timestr).log 2>&1
	sleep 2
	killall tshark

domain_not_block:
	bash capture.sh $@.$(timestr).pcapng </dev/null &
	sleep 2
	-curl --connect-timeout 10 -i https://www.wikipedia.org > $@.$(timestr).log 2>&1
	sleep 2
	killall tshark
	
domain_block:
	bash capture.sh $@.$(timestr).pcapng </dev/null &
	sleep 2
	-curl --connect-timeout 10 -i https://zh.wikipedia.org > $@.$(timestr).log 2>&1
	sleep 2
	killall tshark

url_not_block:
	bash capture.sh $@.$(timestr).pcapng </dev/null &
	sleep 2
	-curl --connect-timeout 10 -i http://www.881903.com/Page/ZH-TW/crfinance.aspx > $@.$(timestr).log 2>&1
	sleep 2
	killall tshark

url_block:
	bash capture.sh $@.$(timestr).pcapng </dev/null &
	sleep 2
	-curl --connect-timeout 10 -i http://www.881903.com/Page/ZH-TW/index.aspx > $@.$(timestr).log 2>&1
	sleep 2
	killall tshark

port_block:
	bash capture.sh $@.$(timestr).pcapng </dev/null &
	sleep 2
	echo QUIT > quit.log
	-./timeout3 -t 20 telnet vpn.hongkong.witopia.net 1194 < quit.log > $@.$(timestr).log 2>&1
	sleep 2
	killall tshark
	
openvpn:
	bash capture.sh $@.$(timestr).pcapng </dev/null &
	sleep 2
	-(cd ~/vpn && openvpn --inactive 5 --config client.conf) > $@.$(timestr).log 2>&1
	sleep 2
	killall tshark
	

clean:
	rm *.log
	rm *.pcapng
