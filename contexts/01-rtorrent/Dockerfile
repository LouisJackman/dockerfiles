# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.1

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update --yes
    apt-get install --yes --no-install-recommends \
        bash-completion \
        rtorrent \
        wget
    rm -fr /var/lib/apt/lists/*

    update-ca-certificates
EOF
USER user

RUN ["mkdir", "/home/user/.rtorrent.rc"]
RUN ["mkdir", "/home/user/Downloads"]
VOLUME /home/user/.rtorrent.rc
VOLUME /home/user/Downloads/

WORKDIR /home/user/Downloads/

ENTRYPOINT ["rtorrent"]
