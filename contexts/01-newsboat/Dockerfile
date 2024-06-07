# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.2

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update --yes
    apt-get install --yes --no-install-recommends \
        bash-completion \
        ca-certificates \
        newsboat
    rm -fr /var/lib/apt/lists/*

    update-ca-certificates
EOF
USER user

RUN ["mkdir", "/home/user/.newsboat"]
VOLUME /home/user/.newsboat/

ENTRYPOINT ["newsboat"]
