#!/bin/bash

echo "setting max output BW for port 443 to $BW_RATE" > /var/tmp/init_sh.out

tc qdisc add dev eth0 root handle 1: htb
tc class add dev eth0 parent 1:1 classid 1:10 htb rate $BW_RATE ceil $BW_CEIL
tc filter add dev eth0 parent 1:0 prio 1 protocol ip handle 10 fw flowid 1:10
iptables -A OUTPUT -t mangle -p tcp --dport 443 -j MARK --set-mark 10

