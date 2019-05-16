FROM node:10-alpine
ADD ./files/supervisor.sh /
RUN chmod +x /supervisor.sh \
    && apk add --no-cache redis git sed \
    && chmod 777 /var/lib/redis \
    && cd /opt \
    && git clone -b v1.x.x https://github.com/NodeBB/NodeBB.git nodebb \
    && cd nodebb \
    && git checkout -b v1.12.2 v1.12.2 \
    && cp install/package.json package.json \
    && npm install --production \
    && rm -r .[!.]* \
    && mkdir -p /etc/nodebb \
    && sed -i '1 idaemonize yes' /etc/redis.conf \
    && sed -i 's/bind 127.0.0.1 ::1/bind 127.0.0.1/' /etc/redis.conf \
    && sed -i 's/appendonly no/appendonly yes/' /etc/redis.conf \
    && sed -i '/save */d' /etc/redis.conf
ENV NODE_ENV=production
WORKDIR /opt/nodebb
EXPOSE 4567
VOLUME ["/etc/nodebb", "/var/lib/redis", "/opt/nodebb/public/uploads"]
ENTRYPOINT ["ash"]
CMD ["/supervisor.sh"]