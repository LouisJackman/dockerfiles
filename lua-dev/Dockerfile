FROM base-dev

ENV LUA_VERSION=5.3

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
			 liblua"$LUA_VERSION"-dev \
			 libluajit-5.1-dev \
			 lua"$LUA_VERSION" \
       gcc \
       luajit \
       luarocks \
       rlwrap \
    && rm -fr /var/lib/apt/lists/*

RUN [ \
    "luarocks", \
    "install", \
    "--server=http://luarocks.org/dev", \
    "lua-lsp", \
    "0.1.0-2", \
    "luacheck", \
    "0.24.0-2", \
    "Formatter", \
    "0.1.1-1", \
    "lua-cjson", \
    "2.1.0.6-1" \
]

USER dev

RUN { \
    echo; \
    echo "alias lua='rlwrap lua'"; \
    echo "alias luajit='rlwrap luajit'"; \
  } >>~/.bashrc

WORKDIR /home/dev/.local/share/nvim/site/pack/default/start

COPY --chown=dev:dev additional_plugins.vim /home/dev/.config/nvim/autoload/

RUN IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +quitall

WORKDIR /home/dev/src

