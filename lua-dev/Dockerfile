FROM base-dev

ENV LUA_VERSION 5.3
ENV VIM_LUA_VERSION_COMMIT 9eecdb726a73e0582fafbb3cde340d61b77b26a9
ENV LUA_FORMATTER_VERSION 0.1.1-1

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
       lua"$LUA_VERSION" \
       luarocks \
       luajit \
    && rm -fr /var/lib/apt/lists/*

USER dev

WORKDIR /home/dev/.local/share/nvim/site/pack/default/start

RUN git clone https://github.com/wsdjeg/vim-lua.git \
    && cd vim-lua \
    && git reset "$VIM_LUA_VERSION_COMMIT"

COPY --chown=dev:dev additional_plugins.vim /home/dev/.config/nvim/autoload/

WORKDIR /home/dev/src

