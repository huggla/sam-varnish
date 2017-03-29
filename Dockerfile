FROM alpine:latest

ENV VARNISH_BACKEND_ADDRESS=192.168.1.65
ENV VARNISH_MEMORY=100M
ENV VARNISH_BACKEND_PORT=80
ENV VARNISH_CONNECT_TIMEOUT=4

EXPOSE 80

RUN apk add --update varnish \
 && rm -rf /var/cache/apk/* \
 && mkdir -p /var/lib/varnish/`hostname` \
 && chown nobody /var/lib/varnish/`hostname`

CMD varnishd -s malloc,${VARNISH_MEMORY} -a :80 -b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT} -p connect_timeout=${VARNISH_CONNECT_TIMEOUT}
