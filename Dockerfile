# Apache ActiveMQ 5.11.1

# FROM parana/jdk8-debian # TODO: Investigar o que ocorre com a JDK da Oracle e ActiveMQ
FROM webcenter/openjdk-jre:8

MAINTAINER João Antonio Ferreira <joao.parana@gmail.com>

# Update distro and install some packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install curl -y && \
    apt-get install supervisor -y && \
    apt-get install logrotate -y && \
    apt-get install locales -y && \
    update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    rm -rf /var/lib/apt/lists/*

# Copy the app setting
COPY assets/init.py /app/init.py
RUN chmod 755 /app/init.py

# Lauch app install
COPY assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

# Expose all port
EXPOSE 8161 
EXPOSE 61616 
EXPOSE 5672
EXPOSE 61613
EXPOSE 1883 
EXPOSE 61614

# Expose some folders
VOLUME ["/data/activemq"]
VOLUME ["/var/log/activemq"]
VOLUME ["/opt/activemq/conf"]

USER root

RUN mkdir -p /data/mq-conf && \
    chmod 777 /data/mq-conf && \
    chown activemq:activemq /data/mq-conf && \
    ls -la /data

# WORKDIR /opt/activemq

# ENTRYPOINT ["/app/init"]
CMD ["/app/init.py", "start"]

