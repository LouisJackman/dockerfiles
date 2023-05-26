# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/base-dev:0.0.1

ARG RUST_VERSION=1.66.0 \
    RUST_ANALYZER_VERSION=2022-11-14

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update

    # Lynx is for browing Rust's documentation without needing to rummage through
    # the container's filesystem with the host's browser.
    apt-get install --yes --no-install-recommends \
        afl++ \
        binutils \
        build-essential \
        gdb \
        llvm \
        lynx \
        manpages \
        manpages-dev \
        rust-gdb \
        strace \
        valgrind

    rm -fr /var/lib/apt/lists/*
EOF
USER user

WORKDIR /home/user

RUN <<-EOF
    curl https://sh.rustup.rs -sSf \
        | sh -s -- -y --default-toolchain "$RUST_VERSION"

    curl \
        --create-dirs \
        -LSfs "https://github.com/rust-analyzer/rust-analyzer/releases/download/$RUST_ANALYZER_VERSION/rust-analyzer-$(uname -m)-unknown-linux-gnu.gz" \
        -o ~/.local/bin/rust-analyzer.gz
    gunzip ~/.local/bin/rust-analyzer.gz
    chmod +rx ~/.local/bin/rust-analyzer

    cp ~/.cargo/env ~/.config/shrc.d/75-rust.sh
    source ~/.cargo/env

    rustup component add rustfmt clippy rust-src rust-analyzer
    cargo version
EOF

COPY --chown=user additional_setup.lua /home/user/.config/nvim/lua/user/
COPY --chown=user plugins.lua /home/user/.config/nvim/lua/user/plugins/rust.lua

RUN nvim --headless -c quitall

WORKDIR /home/user/workspace
