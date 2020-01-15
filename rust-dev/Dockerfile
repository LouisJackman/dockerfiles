FROM base-dev

ENV RUST_VERSION 1.38.0
ENV RUST_VIM_VERSION_COMMIT 05f98470e55722aaf9b1a1ef1eb272f2d95e349d

USER root

RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends build-essential \
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
RUN git \
        clone \
        --depth 1 \
        https://github.com/rust-lang/rust.vim \
    && cd rust.vim \
    && git fetch --depth 1 . "$RUST_VIM_VERSION_COMMIT" \
    && git reset "$RUST_VIM_VERSION_COMMIT"

COPY additional_plugins.vim /home/dev/.local/share/nvim/autoload/

WORKDIR /home/dev/src

ENV USER dev

