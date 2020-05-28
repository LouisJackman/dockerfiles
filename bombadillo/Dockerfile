FROM debian:buster-slim

ENV BOMBADILLO_VERSION 2.3.0
ENV BOMBADILLO_SHA512_SUM 4a8bb3dfae7536052629e41c389383e6608656de9094f0022093c4d0c42be3b512218516c42da5d3d85dacdfba44e0fd6b839400aed1713c0f37051f89b4e9b4

RUN DEBIAN_FRONTEND=noninteractive apt-get update --yes \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        curl \
        unzip \
    && rm -fr /var/lib/apt/lists/*

WORKDIR /opt

RUN curl -OLf http://bombadillo.colorfield.space/binaries/bombadillo-${BOMBADILLO_VERSION}_linux_64.zip

RUN echo "$BOMBADILLO_SHA512_SUM bombadillo-${BOMBADILLO_VERSION}_linux_64.zip" \
    | sha512sum -c -

RUN unzip "bombadillo-${BOMBADILLO_VERSION}_linux_64.zip" \
    && mv bombadillo /usr/local/bin \
    && rm *

RUN chmod +x /usr/local/bin/bombadillo

RUN ["useradd", "-m", "bombadillo"]

USER bombadillo

WORKDIR /home/bombadillo

ENTRYPOINT /usr/local/bin/bombadillo

