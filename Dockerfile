FROM alpine:3.7

ENV PID_FILE="/var/run/varnishd.pid" \
    CONFIG_DIR="/etc/varnish"

COPY ./bin/start.sh /usr/local/bin/start.sh
COPY ./varnish-5.0-configuration-templates/default.vcl $CONFIG_DIR/default.vcl.template

RUN apk --no-cache add varnish sudo \
 && mkdir -p "$(dirname '"$PID_FILE"')" \
 && touch "$PID_FILE" \
 && chmod 500 /usr/local/bin/start.sh \
 && echo "varnish ALL=(root) NOPASSWD:SETENV: /usr/local/bin/start.sh" > /etc/sudoers.d/varnish

ENV JAIL="none" \
    VCL_FILE="$CONFIG_DIR/default.vcl" \
    READ_ONLY_PARAMS="cc_command,vcc_allow_inline_c,vmod_path" \
    LISTEN_ADDRESS="" \
    LISTEN_PORT="6081" \
    MANAGEMENT_ADDRESS="localhost" \
    MANAGEMENT_PORT="6082" \
    STORAGE="malloc,100M" \
    DEFAULT_TTL="120" \
    ADDITIONAL_OPTS="" 

USER varnish

CMD ["sudo", "-E", "start.sh"]
