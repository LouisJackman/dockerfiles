FROM base-dev

ENV RUST_VERSION 1.44.1
ENV RUST_VIM_VERSION_COMMIT 0d8ce07aaa3b95e61bf319b25bb3b1a4ecc780c2
ENV RUST_ANALYZER_VERSION 2020-06-22

USER root

# Lynx is for browing Rust's documentation without needing to rummage through
# the container's filesystem with the host's browser.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends build-essential lynx \
    && rm -fr /var/lib/apt/lists/*

USER dev

WORKDIR /home/dev

RUN curl https://sh.rustup.rs -sSf \
    | sh -s -- -y --default-toolchain "$RUST_VERSION"

RUN curl \
    -LSfs "https://github.com/rust-analyzer/rust-analyzer/releases/download/$RUST_ANALYZER_VERSION/rust-analyzer-linux" \
    -o ~/.local/bin/rust-analyzer
RUN ["chmod", "+x", "/home/dev/.local/bin/rust-analyzer"]

RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "rustfmt"]
RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "clippy"]
RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "rust-src"]

RUN { \
        echo; \
        cat ~/.cargo/env; \
        echo; \
    } >>~/.bashrc

WORKDIR /home/dev/.local/share/nvim/site/pack/default/start
RUN git clone https://github.com/rust-lang/rust.vim \
    && cd rust.vim \
    && git reset "$RUST_VIM_VERSION_COMMIT"

COPY --chown=dev:dev additional_plugins.vim /home/dev/.config/nvim/autoload/

WORKDIR /home/dev/src

ENV USER dev

