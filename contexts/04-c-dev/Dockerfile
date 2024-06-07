# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/base-dev:0.0.2

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get --yes --no-install-recommends install \
        afl++ \
        clang-format \
        g++ \
        valgrind \
        build-essential \
        clangd \
        gdb \
        manpages \
        manpages-dev \
        strace
    rm -fr /var/lib/apt/lists/*
EOF
USER user

COPY --chown=user:user additional_setup.lua /home/user/.config/nvim/lua/user/

RUN nvim --headless -c quitall

