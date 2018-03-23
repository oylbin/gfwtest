docker run --rm -it -v /root/ss:/config --name ss-server --net=host  hitian/ss ss-server -c /config/server_without_obfs.json 
