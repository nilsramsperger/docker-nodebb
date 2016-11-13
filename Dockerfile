FROM debian:latest
RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs
RUN apt-get update \
    && apt-get install -y redis-server imagemagick
RUN apt-get update \
    && apt-get install -y wget \
    && cd /opt \
    && wget https://github.com/NodeBB/NodeBB/archive/v1.3.0.tar.gz \
    && tar -zxvf v1.3.0.tar.gz \
    && rm v1.3.0.tar.gz \
    && mv NodeBB-1.3.0 nodebb \
    && cd nodebb \
    && rm -r .[!.]*
RUN mkdir -p /etc/nodebb
ADD ./files/supervisor.sh /
RUN chmod +x /supervisor.sh
WORKDIR /opt/nodebb
RUN npm install --production
RUN npm install -g forever
RUN /etc/init.d/redis-server start \
    && sleep 5 \
    && redis-cli CONFIG SET save "" \
    && redis-cli CONFIG SET appendonly yes \
    && chmod a+w /etc/redis/redis.conf \
    && redis-cli CONFIG rewrite \
    && chmod a-w /etc/redis/redis.conf
RUN apt-get remove -y curl wget \
    && apt-get autoremove -y \
    && apt-get autoclean -y
EXPOSE 4567
VOLUME ["/etc/nodebb", "/var/lib/redis", "/opt/nodebb/public/uploads"]
ENTRYPOINT ["/supervisor.sh"]