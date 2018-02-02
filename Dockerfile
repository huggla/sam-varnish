FROM alpine:3.7

COPY ./bin/start.sh /usr/local/bin/start.sh
COPY ./varnish-5.0-configuration-templates/default.vcl /tmp/default.vcl

ENV PID_FILE="/var/run/varnishd.pid"

RUN apk --no-cache add varnish \
 && mkdir -p "$(dirname '"$PID_FILE"')" \
 && touch "$PID_FILE" \
 && chown varnish "$PID_FILE" /var/lib/varnish \
 && chmod ugo+x /usr/local/bin/start.sh

ENV JAIL="none" \
    VCL_FILE="/etc/varnish/default.vcl" \
    READ_ONLY_PARAMS="cc_command,vcc_allow_inline_c,vmod_path" \
    LISTEN_ADDRESS="" \
    LISTEN_PORT="6081" \
    MANAGEMENT_ADDRESS="localhost" \
    MANAGEMENT_PORT="6082" \
    STORAGE="malloc,100M" \
    DEFAULT_TTL="120" \
    ADDITIONAL_OPTS="" 

CMD ["start.sh"]
