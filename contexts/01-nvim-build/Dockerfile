# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.2
ARG NEOVIM_VERSION=0.10.0

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        autoconf \
        automake \
        cmake \
        curl \
        g++ \
        gettext \
        git \
        libtool \
        libtool-bin \
        make \
        ninja-build \
        pkg-config \
        unzip \
        xz-utils
    rm -fr /var/lib/apt/lists/*
EOF
USER user

RUN mkdir -p ~/nvim-build
WORKDIR /home/user/nvim-build

RUN <<-EOF
    git clone --depth 1 --branch v"$NEOVIM_VERSION" https://github.com/neovim/neovim
    mkdir -p ~/nvim-build/installation

    cd neovim
    make -j"$(nproc --all)" \
        CMAKE_BUILD_TYPE=Release \
        CMAKE_EXTRA_FLAGS=-DCMAKE_INSTALL_PREFIX="$HOME"/nvim-build/installation
    make install

    cd ~/nvim-build/installation
    tar -cJf ~/nvim.tar.xz .
    rm -r ~/nvim-build
EOF
