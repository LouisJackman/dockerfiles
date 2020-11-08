FROM debian:buster-20201012-slim

ENV BOMBADILLO_VERSION 2.3.1
ENV BOMBADILLO_SHA512_SUM 77acb558a62bf66c8e47be640c4016bb8c72c0096e98c68406d45ba9111e08f60b0d8be27d557caeb953d6d5a3c51cb9d552f7b25a43ff78758424faad423cc2

RUN DEBIAN_FRONTEND=noninteractive apt-get update --yes \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    && rm -fr /var/lib/apt/lists/*

WORKDIR /opt
RUN curl -OLf https://bombadillo.colorfield.space/binaries/bombadillo-${BOMBADILLO_VERSION}_linux_64.zip

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

