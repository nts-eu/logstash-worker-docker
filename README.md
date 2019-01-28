# logstash-worker-docker
Logstash Docker for running on Syslog Worker

Logstash Docker with Lumberjack Output Plugin and Bandwith Limitation for Upstream added.

capability NET_ADMIN needed for tc and iptables command in docker

this is the Docker run command:

docker run --name=logstash-worker  -p 0.0.0.0:514:1514/udp --volume="/opt/docker/logstash-worker/pipeline/:/usr/share/logstash/pipeline/" --volume="/opt/docker/logstash-worker/cert/:/usr/share/logstash/cert/" --detach=true --cap-add=NET_ADMIN -t ntsdev/logstash-worker:latest

###logstash.conf 
placed in pipeline
````
########## Syslogworker Config ##########

input {
  udp {
    port => 1514
  }
}
filter {
  mutate {
    add_field => { 
       "worker" => "my_nagios_prefix"
       "type" => "Syslog"
    }
  }
 }
output {
#  lumberjack {
#    hosts => ["x.x.x.x"]
#    port => 443
#    ssl_certificate => "/usr/share/logstash/cert/lumberjack.pem"
#    id => "localworker"
#    codec => json
#    flush_size => 10
 #   idle_flush_time => 5
 # }
}

