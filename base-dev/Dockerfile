FROM debian:bullseye-20201117-slim

ENV LANG=C.UTF-8

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        bat \
        ca-certificates \
        cloc \
        curl \
        exuberant-ctags \
        fzf \
        git \
        make \
        \
        # Node.js is needed for NeoVim's coc plugin.
        nodejs \
        npm \
        \
        python3 \
        python3-pip \
        python3-setuptools \
        ripgrep \
        tree \
    && rm -fr /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

WORKDIR /opt
RUN curl \
        -LSOfs \
        # TODO: pin to 0.5.0 once it has a stable release.
        'https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz' \
    && tar -xzf nvim-linux64.tar.gz \
    && rm nvim-linux64.tar.gz
ENV PATH=/opt/nvim-linux64/bin:$PATH

RUN ["useradd", "-m", "dev"]

USER dev

RUN mkdir -p "${HOME}/.npm-packages/lib"\
    && npm config set prefix "${HOME}/.npm-packages"

ENV NPM_PACKAGES="$HOME/.npm-packages"
ENV PATH="$PATH:$NPM_PACKAGES/bin"
ENV MANPATH="$MANPATH:$NPM_PACKAGES/share/man"

COPY --chown=dev .bashrc /home/dev/
COPY --chown=dev init.vim /home/dev/.config/nvim/

WORKDIR /home/dev

COPY --chown=dev scripts/configure-nvim.sh /home/dev
RUN sh /home/dev/configure-nvim.sh && rm /home/dev/configure-nvim.sh

ENV PATH=/home/dev/.local/bin:$PATH

RUN ["mkdir", "/home/dev/src"]
VOLUME /home/dev/src
WORKDIR /home/dev/src

