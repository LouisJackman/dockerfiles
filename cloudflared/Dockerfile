FROM debian:bullseye-20201117-slim

ARG ARCH=arm

ENV LANG=C.UTF-8

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
    && rm -fr /var/lib/apt/lists/*

WORKDIR /opt

RUN curl -LSfs -o cloudflared.tgz https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-$ARCH.tgz \
    && tar -xzf cloudflared.tgz \
    && rm cloudflared.tgz \
    && cp ./cloudflared /usr/local/bin \
    && chmod +x /usr/local/bin/cloudflared

ENV CLOUDFLARED_OPTS='--port 5053 --upstream https://1.1.1.1/dns-query --upstream https://1.0.0.1/dns-query'

# TODO: work out why using a non-root user account causes Go panics.

EXPOSE 5053
ENTRYPOINT /usr/local/bin/cloudflared
CMD proxy-dns $CLOUDFLARED_OPTS

