FROM node:8-alpine
ADD ./files/supervisor.sh /
ADD ./files/redis /etc/init.d/
RUN chmod +x /supervisor.sh \
    && chmod +x /etc/init.d/redis \
    && apk add --no-cache redis git sed openrc \
    && chmod 777 /var/lib/redis \
    && cd /opt \
    && git clone -b v1.x.x https://github.com/NodeBB/NodeBB.git nodebb \
    && cd nodebb \
    && git checkout -b v1.12.0 v1.12.0 \
    && cp install/package.json package.json \
    && npm install --production \
    && rm -r .[!.]* \
    && mkdir -p /etc/nodebb \
    && sed -i 's/bind 127.0.0.1 ::1/bind 127.0.0.1/' /etc/redis.conf \
    && sed -i 's/appendonly no/appendonly yes/' /etc/redis.conf \
    && sed -i '/save */d' /etc/redis.conf
ENV NODE_ENV=production
WORKDIR /opt/nodebb
EXPOSE 4567
VOLUME ["/etc/nodebb", "/var/lib/redis", "/opt/nodebb/public/uploads"]
ENTRYPOINT ["ash"]
CMD ["/supervisor.sh"]