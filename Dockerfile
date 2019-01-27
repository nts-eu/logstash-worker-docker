FROM docker.elastic.co/logstash/logstash:6.4.3

COPY ./init.sh /opt/init.sh
COPY ./extnts_root_ca.pem /etc/pki/ca-trust/source/anchors/extnts_root_ca.pem
COPY ./custom.service /etc/systemd/system/custom.service

RUN logstash-plugin install logstash-input-lumberjack
RUN logstash-plugin install logstash-output-lumberjack
RUN logstash-plugin install logstash-filter-json_encode

USER root
RUN update-ca-trust
RUN yum install -y \
    iproute \
    iptables \
    net-tools 
RUN chmod +x /opt/init.sh
RUN systemctl enable custom.service

USER logstash

ENV XPACK_MONITORING_ENABLED false
ENV BW_RATE 5mbit
ENV BW_CEIL 10mbit
ENV OUTPUT_LUMBERJACK_HOSTS: ['1.1.1.1']
ENV OUTPUT_LUMBERJACK_PORT: 443
ENV OUTPUT_LUMBERJACK_SSL_CERTIFICATE: /usr/share/logstash/cert/lumberjack.pem
ENV OUTPUT_LUMBERJACK_ID: docker
ENV OUTPUT_LUMBERJACK_CODEC: json
ENV OUTPUT_LUMBERJACK_FLUSH_SIZE: 500
ENV OUTPUT_LUMBERJACK_IDLE_FLUSH_TIME: 15 
ENV INPUT_UDP_PORT: 1514
ENV INPUT_UDP_ADD_FIELD: {'worker':'prefix','type':'Syslog'}

VOLUME ["/usr/share/logstash/cert/","/usr/share/logstash/pipeline/"]
