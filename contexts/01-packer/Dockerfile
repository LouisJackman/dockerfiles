# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.2

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        bash-completion \
        packer
    rm -fr /var/lib/apt/lists/*
EOF
USER user

