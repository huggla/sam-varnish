# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="1.0"
ARG TAG="20190927"
ARG IMAGETYPE="application"
ARG RUNDEPS="varnish dropbear-ssh"
ARG STARTUPEXACUTABLES="/usr/sbin/varnishd"
ARG EXECUTABLES="/usr/bin/ssh /usr/bin/varnishhist /usr/bin/varnishtest /usr/bin/varnishtop /usr/bin/varnishlog /usr/bin/varnishadm /usr/bin/varnishstat /usr/bin/varnishncsa"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$SaM_VERSION-$TAG}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/build:$SaM_VERSION-$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$SaM_VERSION-$TAG} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
ENV VAR_CONFIG_DIR="/etc/varnish" \
    VAR_PID_FILE="/var/run/varnishd.pid"
    VAR_JAIL="none" \
    VAR_VCL_FILE="\$VAR_CONFIG_DIR/default.vcl" \
    VAR_READ_ONLY_PARAMS="cc_command,vcc_allow_inline_c,vmod_path" \
    VAR_LISTEN_ADDRESS="" \
    VAR_LISTEN_PORT="6081" \
    VAR_MANAGEMENT_ADDRESS="localhost" \
    VAR_MANAGEMENT_PORT="6082" \
    VAR_STORAGE="malloc,100M" \
    VAR_DEFAULT_TTL="120" \
    VAR_ADDITIONAL_OPTS="" \
    VAR_FINAL_COMMAND="varnishd -j \$VAR_JAIL -P \"\$VAR_PID_FILE\" -f \"\$VAR_VCL_FILE\" -r \$VAR_READ_ONLY_PARAMS -a \$VAR_LISTEN_ADDRESS:\$VAR_LISTEN_PORT -T \$VAR_MANAGEMENT_ADDRESS:\$VAR_MANAGEMENT_PORT -s \$VAR_STORAGE -t \$VAR_DEFAULT_TTL -F \$VAR_ADDITIONAL_OPTS"

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
