FROM base-dev

ENV RUST_VER 1.38.0

USER root

RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends build-essential \
    && rm -fr /var/lib/apt/lists/*

USER dev

WORKDIR /home/dev

RUN curl https://sh.rustup.rs -sSf \
    | sh -s -- -y --default-toolchain "$RUST_VER"

RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "rustfmt"]
RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "clippy"]

RUN { \
    echo; \
    cat ~/.cargo/env; \
    echo; \
} >>~/.zshrc

RUN [ \
    "git", \
    "clone", \
    "https://github.com/rust-lang/rust.vim", \
    "/home/dev/.vim/pack/default/start/rust.vim" \
]

COPY additional_plugins.vim /home/dev/.vim/autoload/

WORKDIR /home/dev/src

ENV USER dev

