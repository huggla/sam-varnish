FROM alpine:latest

ENV VARNISH_BACKEND_ADDRESS=192.168.1.65
ENV VARNISH_MEMORY=100M
ENV VARNISH_BACKEND_PORT=80
ENV VARNISH_CONNECT_TIMEOUT=4
ENV VARNISH_MAX_RETRIES=4
ENV VARNISH_MAX_RESTARTS=4

EXPOSE 80

VOLUME ["/etc/varnish"]

RUN apk --no-cache add varnish \
 && mkdir -p /var/lib/varnish/`hostname` \
 && chown nobody /var/lib/varnish/`hostname`

CMD varnishd -F -s malloc,${VARNISH_MEMORY} -a :80 -b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT} -p max_retries=${VARNISH_MAX_RETRIES} -p max_restarts=${VARNISH_MAX_RESTARTS} -p connect_timeout=${VARNISH_CONNECT_TIMEOUT}
