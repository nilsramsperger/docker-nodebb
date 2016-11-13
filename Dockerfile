FROM debian:latest
RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs
RUN apt-get update \
    && apt-get install -y redis-server imagemagick git build-essential
RUN cd /opt \
    && git clone -b v1.x.x https://github.com/NodeBB/NodeBB.git nodebb \
    && cd nodebb \
    && git checkout -b v1.3.0 v1.3.0
RUN mkdir -p /etc/nodebb
ADD ./files/supervisor.sh /
RUN chmod +x /supervisor.sh
WORKDIR /opt/nodebb
RUN npm install
RUN npm install -g forever
RUN /etc/init.d/redis-server start \
    && sleep 5 \
    && redis-cli CONFIG SET save "" \
    && redis-cli CONFIG SET appendonly yes \
    && chmod a+w /etc/redis/redis.conf \
    && redis-cli CONFIG rewrite \
    && chmod a-w /etc/redis/redis.conf
EXPOSE 4567
VOLUME ["/etc/nodebb", "/var/lib/redis", "/opt/nodebb/public/uploads"]
ENTRYPOINT ["/supervisor.sh"]