# 科学上网经验分享演示命令

http://packetlife.net/blog/2008/oct/18/cheat-sheets-tcpdump-and-wireshark/

### 演示DNS污染

抓包

    tshark -f "port 53" -P -w dns_pollution.pcapng
    
依次执行以下命令，观察现象

    dig www.baidu.com
    dig www.google.com
    dig www.google.com @8.8.8.8

    # 一个不存在的dns服务器
    dig www.baidu.com @13.75.126.141
    dig www.google.com @13.75.126.141
    
    # TODO 自建海外DNS观察效果
    
### 演示域名封锁
      
抓包

    ./capture domain_not_block
    
发请求

    curl --connect-timeout 10 -i https://www.wikipedia.org
    
抓包

    ./capture domain_block

发请求

    curl --connect-timeout 10 -i https://zh.wikipedia.org
    
wireshark打开抓包文件看结果

### 演示URL封锁

抓包

    ./capture url_not_block
    
发请求

    curl --connect-timeout 10 -i http://www.881903.com/Page/ZH-TW/crfinance.aspx
    
抓包

    ./capture url_block
    
发请求

    curl --connect-timeout 10 -i http://www.881903.com/Page/ZH-TW/index.aspx
    
打开抓包文件看结果，可以看到RST现象


# 演示暂停
# 演示暂停
# 演示暂停


### 演示OpenVPN

抓包

    ./capture openvpn

看一下网卡设备

    ifconfig
    
拨vpn

    (cd vpn && openvpn --config client.conf)
    
再看看网卡设备，多了一个tap0

    ifconfig

打开抓包文件看结果，协议容易识别

* wireshark打开文件之后，用OpenVPN解析协议
* 找比较大的数据包，传输内容里能看到明文的openvpn字样



# 演示暂停
# 演示暂停
# 演示暂停


### 演示 HTTP代理 

启动http代理服务器，窗口1执行

    mitmproxy -p 10080

窗口2抓包

    ./capture http_proxy

本地打开窗口3，执行

    http_proxy=http://proxy:10080 curl http://ip.cn
    https_proxy=http://proxy:10080 curl https://ouyang.me -k

打开抓包文件看结果

### 演示 socks代理

启动SOCK代理服务器，窗口1执行

    danted -d
    
窗口2抓包

    ./capture socks
    
本地窗口3执行

    curl --socks5-hostname proxy:10080 http://ip.cn
    
打开抓包文件看结果，wireshark打开时

* 可以用`tcp.len > 0`过滤掉不相关的包
* 10080端口用socks协议解析

# 演示暂停
# 演示暂停
# 演示暂停

### 演示ssh tunnel

SSH连 proxy，同时用-D参数创建一个tunnel

    ssh -D 9999 root@proxy
    
本地窗口3执行，对比直连和走代理的IP差异。

    curl https://myip.ipip.net
    curl --socks5-hostname 127.0.0.1:9999 https://myip.ipip.net

抓包看看数据，远程窗口1抓包

    ./capture tunnel

为了方便区分数据，这次建连接换12345端口

    ssh -D 9999 -p12345 root@proxy
    
本地执行

    curl --socks5-hostname 127.0.0.1:9999 http://ip.cn

wireshark里看抓包结果
* 把12345端口数据用SSH协议解析。Decode As 里选。
* 过滤条件`tcp.len > 0 or udp`

# 演示暂停
# 演示暂停
# 演示暂停

### 演示 shadowsocks

proxy上启动server

    (cd ss && docker run --rm -it -v /root/ss:/config --name ss-server --net=host  hitian/ss ss-server -c /config/server_without_obfs.json )

如果上面的命令报错提示`The container name "/ss-server" is already in use by ...`，那么先执行下面的命令把之前的docker进程杀死

    docker stop ss-server
    docker rm ss-server
    
本地启动client

    docker run --rm -it -v /Users/Shared/科学上网分享:/config --name ss-client -p 10080:10080  hitian/ss ss-local -c /config/client.json -b 0.0.0.0
    
远程抓包

    ./capture shadowsocks

本地发起请求
    
    curl --socks5-hostname 127.0.0.1:10080 http://ip.cn
    
wireshark打开文件看抓包数据
    
# 演示暂停
# 演示暂停
# 演示暂停

### 演示 shadowsocks with obfs    

proxy上启动server

    (cd ss && docker run --rm -it -v /root/ss:/config --name ss-server --net=host hitian/ss ss-server -c /config/server.json)
    
如果上面的命令报错提示`The container name "/ss-server" is already in use by ...`，那么先执行下面的命令把之前的docker进程杀死

    docker stop ss-server
    docker rm ss-server

本地启动client

    docker run --rm -it -v /Users/Shared/科学上网分享:/config --name ss-client -p 10080:10080  hitian/ss ss-local -c /config/client_obfs.json -b 0.0.0.0

远程抓包

    ./capture shadowsocks_obfs

本地发请求

    curl --socks5-hostname 127.0.0.1:10080 http://ip.cn

wireshark里看抓包结果
* decode设置，4545端口用SSL协议，（可以对比以下无obfs的抓包结果，是无法用ssl协议解析的）。
* 注意观察client与proxy之间的请求响应传输数据量变大了。



