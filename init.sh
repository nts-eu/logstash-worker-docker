#!/bin/bash

echo "setting max output BW for port 443 to $BW_RATE" > /var/tmp/init_sh.out

(( priorate = BW_RATE * 2 ))
(( totalrate = BW_RATE * 4 ))
(( totalceil = totalrate - 1))

tc qdisc del dev eth0 root  2> /dev/null > /dev/null
tc qdisc add dev eth0 root handle 1: htb default 6
tc class add dev eth0 parent 1: classid 1:1 htb rate ${totalrate}mbit ceil ${totalrate}mbit
tc class add dev eth0 parent 1:1 classid 1:5 htb rate ${priorate}mbit ceil ${BW_RATE}mbit
tc filter add dev eth0 protocol ip parent 1:0 prio 0 u32 match ip dst ${LUMBERJACK_SERVER}/32 flowid 1:5
tc class add dev eth0 parent 1:1 classid 1:6 htb rate 0.5mbit ceil ${totalceil}mbit
tc qdisc add dev eth0 parent 1:5 handle 5: sfq perturb 10
tc qdisc add dev eth0 parent 1:6 handle 6: sfq perturb 10

exec /usr/local/bin/docker-entrypoint
