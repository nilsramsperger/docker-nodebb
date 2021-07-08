FROM node:14-alpine AS build
RUN apk add --no-cache redis git sed \
    && cd /opt \
    && git clone -b v1.x.x https://github.com/NodeBB/NodeBB.git nodebb \
    && cd nodebb \
    && git checkout -b v1.17.2 v1.17.2 \
    && cp install/package.json package.json \
    && npm install --production \
    && sed -i '1 idaemonize yes' /etc/redis.conf \
    && sed -i 's/bind 127.0.0.1 ::1/bind 127.0.0.1/' /etc/redis.conf \
    && sed -i 's/appendonly no/appendonly yes/' /etc/redis.conf \
    && sed -i '/save */d' /etc/redis.conf

FROM node:14-alpine
ADD ./files/supervisor.sh /
RUN chmod +x /supervisor.sh \
    && apk add --no-cache redis \
    && mkdir -p /etc/nodebb \
    && chmod 777 /var/lib/redis
COPY --from=build /etc/redis.conf /etc
COPY --from=build /opt/nodebb /opt/nodebb
ENV NODE_ENV=production
WORKDIR /opt/nodebb
EXPOSE 4567
VOLUME ["/etc/nodebb", "/var/lib/redis", "/opt/nodebb/public/uploads"]
ENTRYPOINT ["ash"]
CMD ["/supervisor.sh"]
