# Secure and Minimal Docker-image of Varnish
# https://hub.docker.com/repository/docker/huggla/sam-varnish

# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="dev"
ARG IMAGETYPE="application"
ARG CLONEGITS="https://github.com/mattiasgeniar/varnish-6.0-configuration-templates.git"
ARG RUNDEPS="varnish dropbear-ssh"
ARG MAKEDIRS="/var/lib/varnish"
ARG GID0WRITABLES="/var/lib/varnish"
ARG EXECUTABLES="/usr/sbin/varnishd /usr/bin/ssh /usr/bin/dbclient /usr/bin/varnishhist /usr/bin/varnishtest /usr/bin/varnishtop /usr/bin/varnishlog /usr/bin/varnishadm /usr/bin/varnishstat /usr/bin/varnishncsa"
ARG BUILDCMDS=\
"   cd varnish-6.0-configuration-templates "\
'&& cp default.vcl "$DESTDIR/" '\
'&& gzip "$DESTDIR/default.vcl"'
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/secure_and_minimal:$SaM_VERSION-base}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/secure_and_minimal:$SaM_VERSION-build} as build
FROM ${BASEIMAGE:-huggla/secure_and_minimal:$SaM_VERSION-base} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
