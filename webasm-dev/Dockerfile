FROM base-dev

ENV WABT_VERSION 1.0.12

USER root
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends clang cmake \
    && rm -fr /var/lib/apt/lists/*
USER dev

RUN git \
    clone \
    --recursive \
    --depth 1 \
    https://github.com/WebAssembly/wabt \
    /home/dev/wabt \
    --branch "$WABT_VERSION"

WORKDIR /home/dev/wabt
RUN ["make"]
ENV PATH $PATH:/home/dev/wabt/bin

WORKDIR /home/dev/src

