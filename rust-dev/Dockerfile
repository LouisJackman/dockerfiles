FROM base-dev

ENV RUST_VERSION 1.41.0
ENV RUST_VIM_VERSION_COMMIT db0137dfad4690621e01dbae780fb4a2dd7dbf27

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

RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "rustfmt"]
RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "clippy"]

RUN { \
    echo; \
    cat ~/.cargo/env; \
    echo; \
} >>~/.zshrc

WORKDIR /home/dev/.local/share/nvim/site/pack/default/start
RUN git clone https://github.com/rust-lang/rust.vim \
    && cd rust.vim \
    && git reset "$RUST_VIM_VERSION_COMMIT"

COPY additional_plugins.vim /home/dev/.local/share/nvim/autoload/

WORKDIR /home/dev/src

ENV USER dev

