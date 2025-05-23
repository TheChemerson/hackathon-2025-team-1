FROM --platform=linux/amd64 ubuntu:latest
EXPOSE 7222

ADD image/*.gz /
COPY config/* /opt/tibco/ems/config/

RUN apt-get -y update \
 && apt-get -y install libjemalloc-dev bash-completion \
 && apt-get clean all \
 && groupadd -r -g 433 tibco-group \
 && useradd -u 431 -r -m -g tibco-group -d /home/tibco-user -s /bin/bash tibco-user \
 && mkdir -p /tmp/tibco/ems/datastore \
 && chown -R tibco-user /home/tibco-user \
 && chown -R tibco-user /opt/tibco/ems/config \
 && chown -R tibco-user /tmp/tibco/ems/datastore

USER tibco-user
ENTRYPOINT ["/opt/tibco/ems/10.2/bin/tibemsd", "-config", "/opt/tibco/ems/config/tibemsd.conf"] 
