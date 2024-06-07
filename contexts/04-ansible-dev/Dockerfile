# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/base-dev:0.0.2

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive

    apt-get update
    apt-get install --yes --no-install-recommends ansible
    rm -fr /var/lib/apt/lists/*
EOF
USER user

