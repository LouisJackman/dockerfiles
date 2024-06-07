# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/base-dev:0.0.2

ARG LUA_VERSION=5.4 \
    LUA_LSP_VERSION=0.1.0-2 \
    LUACHECK_VERSION=1.0.0-1 \
    FORMATTER_VERSION=0.1.1-1 \
    LUA_CJSON_VERSION=2.1.0.10-1 \
    LUA_LANGUAGE_SERVER_VERSION=3.5.6 \
    \
    LUA_LANGUAGE_SERVER_ARM64_SHA512_SUM=93ecc19b96d892013cb3fb71d83c68100d66f33a2c237773763a661ac36c945221bad5077271d4cd7993b57a3450243497edc1c22ee22efcf1552326e405dec3 \
    LUA_LANGUAGE_SERVER_AMD64_SHA512_SUM=4816876bf56e4d85a55b97d1a1f2b3af50f1a67fad035fe66fba6a179a9ca7c74552261ceb92ad9430f5ac27d6d72c29a621949a74f1010f1ea2a9d830969db8

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        liblua"$LUA_VERSION"-dev \
        libluajit-5.1-dev \
        lua"$LUA_VERSION" \
        gcc \
        luajit \
        luarocks \
        rlwrap
    rm -fr /var/lib/apt/lists/*
EOF
USER user

ENV PATH="$PATH:/home/user/.luarocks/bin"

COPY --chown=user lua.sh /home/user/.config/shrc.d/75-lua.sh

RUN <<-EOF
    # Recent versions of luarocks raise a "too many arguments" error when
    # passing multiple packages at once. Work around that by installing each
    # package with its own luarocks invocation.
    luarocks install --local --server=https://luarocks.org/dev lua-lsp "$LUA_LSP_VERSION"
    luarocks install --local --server=https://luarocks.org/dev luacheck "$LUACHECK_VERSION"
    luarocks install --local --server=https://luarocks.org/dev Formatter "$FORMATTER_VERSION"
    luarocks install --local --server=https://luarocks.org/dev lua-cjson "$LUA_CJSON_VERSION"

    uname_m=$(uname -m)
    readonly uname_m
    case "$uname_m" in
        aarch64)
            lua_language_server_arch=arm64
            lua_language_server_sha512_sum="$LUA_LANGUAGE_SERVER_ARM64_SHA512_SUM"
            ;;
        x86_64)
            lua_language_server_arch=x64
            lua_language_server_sha512_sum="$LUA_LANGUAGE_SERVER_AMD64_SHA512_SUM"
            ;;
        *)
            echo unsupported arch "$uname_m" >&2
            exit 1
            ;;
    esac
    readonly lua_language_server_arch
    readonly lua_language_server_sha512_sum

    mkdir -p ~/.local/lua-language-server
    cd ~/.local/lua-language-server
    curl -LSOfs "https://github.com/sumneko/lua-language-server/releases/download/${LUA_LANGUAGE_SERVER_VERSION}/lua-language-server-${LUA_LANGUAGE_SERVER_VERSION}-linux-${lua_language_server_arch}.tar.gz"
    echo "$lua_language_server_sha512_sum lua-language-server-${LUA_LANGUAGE_SERVER_VERSION}-linux-${lua_language_server_arch}.tar.gz" \
        | sha512sum --check
    tar -xzf "lua-language-server-${LUA_LANGUAGE_SERVER_VERSION}-linux-${lua_language_server_arch}.tar.gz"
    mv lua-language-server* lua-language-server
EOF

COPY --chown=user additional_setup.lua /home/user/.config/nvim/lua/user/
COPY --chown=user plugins.lua /home/user/.config/nvim/lua/user/plugins/lua.lua

RUN nvim --headless -c quitall

WORKDIR /home/user/workspace

