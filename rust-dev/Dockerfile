FROM base-dev

ENV RUST_VERSION=1.44.1
ENV RUST_ANALYZER_VERSION=2020-06-22

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
    --create-dirs \
    -LSfs "https://github.com/rust-analyzer/rust-analyzer/releases/download/$RUST_ANALYZER_VERSION/rust-analyzer-linux" \
    -o ~/.config/coc/extensions/coc-rust-analyzer-data/rust-analyzer
RUN ["chmod", "+x", "/home/dev/.config/coc/extensions/coc-rust-analyzer-data/rust-analyzer"]

RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "rustfmt"]
RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "clippy"]
RUN ["/home/dev/.cargo/bin/rustup", "component", "add", "rust-src"]

RUN { \
        echo; \
        cat ~/.cargo/env; \
        echo; \
    } >>~/.bashrc

COPY --chown=dev:dev additional_plugins.vim /home/dev/.config/nvim/autoload/

RUN IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +'CocInstall -sync coc-rust-analyzer' +quitall

WORKDIR /home/dev/src

ENV USER=dev

