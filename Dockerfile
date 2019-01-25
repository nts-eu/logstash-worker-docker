FROM docker.elastic.co/logstash/logstash:6.4.0

COPY ./init.sh /opt/init.sh

COPY ./extnts_root_ca.pem /etc/pki/ca-trust/source/anchors/extnts_root_ca.pem
RUN su update-ca-trust

RUN su yum install -y \
    iproute \
    iptables \
    net-tools 

RUN logstash-plugin install logstash-input-lumberjack
RUN logstash-plugin install logstash-output-lumberjack
RUN logstash-plugin install logstash-filter-json_encode
RUN /opt/init.sh

ENV BW_RATE 5mbit
ENV BW_CEIL 10mbit
