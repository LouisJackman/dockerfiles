# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/web-dev:0.0.1

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get --yes --no-install-recommends install \
        hugo
    rm -fr /var/lib/apt/lists/*
EOF
USER user

