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

ENV XPACK_MONITORING_ENABLED false
ENV BW_RATE 5mbit
ENV BW_CEIL 10mbit

VOLUME ["/usr/share/logstash/cert/","/usr/share/logstash/pipeline/"]

ENTRYPOINT "/opt/init.sh"
