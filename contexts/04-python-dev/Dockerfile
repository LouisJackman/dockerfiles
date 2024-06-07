# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/base-dev:0.0.2

# Match the version in distroless's Python image.
ARG BLACK_VERSION=22.10.0 \
    FLAKE8_VERSION=5.0.4 \
    ISORT_VERSION=5.10.1 \
    JEDI_LANGUAGE_SERVER=0.40.0 \
    PYRIGHT_VERSION=1.1.276

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update

    # Node.js and NPM are used by pyright.
    apt-get install --yes --no-install-recommends \
        nodejs \
        npm \
        pipx

    rm -fr /var/lib/apt/lists/*
EOF
USER user

RUN <<-EOF
    for pkg in \
        jedi-language-server=="$JEDI_LANGUAGE_SERVER" \
        black=="$BLACK_VERSION" \
        isort=="$ISORT_VERSION" \
        flake8=="$FLAKE8_VERSION"
    do
        pipx install "$pkg"
    done

    mkdir -p ~/.npm-packages/lib
    npm config set prefix ~/.npm-packages
EOF

ENV NPM_PACKAGES="/home/user/.npm-packages"
ENV PATH="$PATH:$NPM_PACKAGES/bin"

RUN npm install --global "pyright@$PYRIGHT_VERSION"

COPY --chown=user additional_setup.lua /home/user/.config/nvim/lua/user/

RUN nvim --headless -c quitall

