FROM docker.elastic.co/logstash/logstash:6.4.0

COPY ./init.sh /opt/init.sh
COPY 

RUN yum install -y \
    iproute \
    iptables \
    net-tools 

RUN update-ca-trust
RUN logstash-plugin install logstash-input-lumberjack
RUN logstash-plugin install logstash-output-lumberjack
RUN logstash-plugin install logstash-filter-json_encode
RUN /opt/init.sh

ENV BW_RATE
ENV BW_CEIL
