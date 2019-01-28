FROM docker.elastic.co/logstash/logstash:6.4.3

COPY ./init.sh /opt/init.sh
COPY ./extnts_root_ca.pem /etc/pki/ca-trust/source/anchors/extnts_root_ca.pem
COPY ./custom.service /etc/systemd/system/custom.service

RUN rm -f /usr/share/logstash/pipeline/logstash.conf
RUN logstash-plugin install logstash-input-lumberjack
RUN logstash-plugin install logstash-output-lumberjack
RUN logstash-plugin install logstash-filter-json_encode

USER root
RUN update-ca-trust
RUN yum install -y \
    iproute \
    iptables \
    net-tools 
RUN tc qdisc add dev eth0 root handle 1: htb
RUN tc class add dev eth0 parent 1:1 classid 1:10 htb rate 5mbit ceil 10mbit
RUN tc filter add dev eth0 parent 1:0 prio 1 protocol ip handle 10 fw flowid 1:10
RUN iptables -A OUTPUT -t mangle -p tcp --dport 443 -j MARK --set-mark 10

USER logstash

ENV XPACK_MONITORING_ENABLED false
ENV BW_RATE 5mbit
ENV BW_CEIL 10mbit

VOLUME ["/usr/share/logstash/cert/","/usr/share/logstash/pipeline/"]
