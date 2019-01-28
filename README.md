# logstash-worker-docker
Logstash Docker for running on Syslog Worker

Logstash Docker with Lumberjack Output Plugin and Bandwith Limitation for Upstream added.

capability NET_ADMIN needed for tc and iptables command in docker

this is the Docker run command:

docker run --name=logstash-worker  -p 0.0.0.0:514:1514/udp --volume="/opt/docker/logstash-worker/pipeline/:/usr/share/logstash/pipeline/" --volume="/opt/docker/logstash-worker/cert/:/usr/share/logstash/cert/" --detach=true --cap-add=NET_ADMIN -t ntsdev/logstash-worker:latest
