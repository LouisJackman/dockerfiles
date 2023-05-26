# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/base-dev:0.0.1

# Rely on Debian Testing having a somewhat-recent LTS release of Node.js.

ARG ESLINT_VERSION=8.26.0 \
    PRETTIER_VERSION=2.7.1 \
    TYPESCRIPT_VERSION=4.8.4 \
    TYPESCRIPT_LANGUAGE_SERVER_VERSION=2.1.0

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update

    # node-gyp support is needed for ARM builds of some packages.
    # ca-certificates is used by it to do HTTP downloads. build-essential and
    # python3 are needed for it trigger native compilations, likely due to
    # prebuilt ARM64 binaries missing somewhere.
    apt-get install --yes --no-install-recommends \
        build-essential \
        ca-certificates \
        nodejs \
        npm \
        python3
    rm -fr /var/lib/apt/lists/*

    update-ca-certificates
EOF

USER user

RUN <<-EOF
    mkdir -p ~/.local/npm-global-packages
    npm config set prefix ~/.local/npm-global-packages
EOF

ENV NPM_PACKAGES=/home/user/.local/npm-global-packages
ENV PATH="$PATH:$NPM_PACKAGES/bin"

# Tell Node.js to honour the system truststore to simplify scenarios in which
# custom trusted roots are added.
ENV NODE_OPTIONS=--use-openssl-ca

RUN npm \
        install \
        --global \
        "eslint@$ESLINT_VERSION" \
        "prettier@$PRETTIER_VERSION" \
        "typescript@$TYPESCRIPT_VERSION" \
        "typescript-language-server@$TYPESCRIPT_LANGUAGE_SERVER_VERSION"

COPY --chown=user additional_setup.lua /home/user/.config/nvim/lua/user/
COPY --chown=user plugins.lua /home/user/.config/nvim/lua/user/plugins/node.lua

RUN nvim --headless -c quitall

