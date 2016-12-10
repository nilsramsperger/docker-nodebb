FROM ubuntu:latest
RUN apt-get update \
    && apt-get install -y curl redis-server imagemagick git\
    && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs
RUN cd /opt \
    && git clone -b v1.x.x https://github.com/NodeBB/NodeBB.git nodebb \
    && cd nodebb \
    && git checkout -b v1.2.1 v1.2.1 \
    && rm -r .[!.]*
RUN mkdir -p /etc/nodebb
ADD ./files/supervisor.sh /
RUN chmod +x /supervisor.sh
WORKDIR /opt/nodebb
RUN npm install --production \
    && npm install -g forever \
    && cp node_modules/socket.io-client/dist/socket.io.js node_modules/socket.io-client/socket.io.js
RUN /etc/init.d/redis-server start \
    && sleep 5 \
    && redis-cli CONFIG SET save "" \
    && redis-cli CONFIG SET appendonly yes \
    && chmod a+w /etc/redis/redis.conf \
    && redis-cli CONFIG rewrite \
    && chmod a-w /etc/redis/redis.conf
RUN apt-get remove -y curl git \
    && apt-get autoremove -y \
    && apt-get autoclean -y
EXPOSE 4567
VOLUME ["/etc/nodebb", "/var/lib/redis", "/opt/nodebb/public/uploads"]
ENTRYPOINT ["/supervisor.sh"]