# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.2

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update --yes
    apt-get install --yes --no-install-recommends \
        bash-completion \
        gnupg \
        neovim \
        pass
    rm -fr /var/lib/apt/lists/*

    update-ca-certificates
EOF
USER user

ENV VISUAL=nvim \
    EDITOR=nvim

RUN ["mkdir", "/home/user/.gnupg"]
RUN ["mkdir", "/home/user/.password-store"]
VOLUME /home/user/.gnupg/
VOLUME /home/user/.password-store/
