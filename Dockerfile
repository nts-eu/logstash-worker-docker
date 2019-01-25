FROM docker.elastic.co/logstash/logstash:6.4.0

COPY ./init.sh /opt/init.sh

RUN logstash-plugin install logstash-input-lumberjack
RUN logstash-plugin install logstash-output-lumberjack
RUN logstash-plugin install logstash-filter-json_encode

ENV BW_RATE
ENV BW_CEIL

CMD /opt/init.sh
