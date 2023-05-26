# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.1

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        bash-completion \
        stow
    rm -fr /var/lib/apt/lists/*
EOF
USER user

VOLUME /home/user/workspace
