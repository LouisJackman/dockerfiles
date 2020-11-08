FROM debian:buster-20201012-slim

ENV LANG C.UTF-8
ENV NEOVIM_VERSION=0.4.3

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        ca-certificates \
        cloc \
        curl \
        git \
        make \
        tree \
        python3 \
        python3-pip \
        python3-setuptools \
    && rm -fr /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

WORKDIR /opt
RUN curl \
        -LSOfs \
        "https://github.com/neovim/neovim/releases/download/v$NEOVIM_VERSION/nvim-linux64.tar.gz" \
    && tar -xzf nvim-linux64.tar.gz \
    && rm nvim-linux64.tar.gz
ENV PATH "/opt/nvim-linux64/bin:$PATH"

RUN ["useradd", "-m", "dev"]

USER dev

COPY --chown=dev .bashrc /home/dev/
COPY --chown=dev init.vim /home/dev/.config/nvim/

COPY --chown=dev scripts/configure-nvim.sh /home/dev
RUN sh /home/dev/configure-nvim.sh && rm /home/dev/configure-nvim.sh

ENV PATH "/home/dev/.local/bin:$PATH"

RUN ["mkdir", "/home/dev/src"]
VOLUME /home/dev/src
WORKDIR /home/dev/src

