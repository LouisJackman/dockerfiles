FROM base-dev

# LTS Release
ENV NODE_VERSION 12.14.1

ENV NVIM_JAVASCRIPT_VERSION_COMMIT 2e4a8c485cdf601bb2f2761ea68c09750a0b82e0
ENV NVIM_JSX_PRETTY_VERSION v3.0.0
ENV NVIM_TYPESCRIPT_VERSION_COMMIT 616186fd8a04afa32bae8dc0b70ab7f9cdb427fd
ENV NVIM_TSX_VERSION_COMMIT 77c89c42e189fefd3c9a632b37b7e3b3b9edf918

RUN curl -O https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh \
    && chmod +x install.sh \
    && ./install.sh \
    && rm install.sh

RUN . ~/.nvm/nvm.sh \
    && nvm install "$NODE_VERSION"

RUN . ~/.nvm/nvm.sh && npm \
    install \
    --global \
    eslint \
    prettier \
    typescript \
    create-react-app


WORKDIR /home/dev/.local/share/nvim/site/pack/default/start
RUN git clone https://github.com/pangloss/vim-javascript \
    && git clone --depth 1 https://github.com/MaxMEllon/vim-jsx-pretty --branch "$NVIM_JSX_PRETTY_VERSION" \
    && git clone https://github.com/leafgarland/typescript-vim \
    && git clone https://github.com/ianks/vim-tsx \
    \
    # Some Vim plugins have no release tags or very outdated latest versions.
    && cd vim-javascript && git reset "$NVIM_JAVASCRIPT_VERSION_COMMIT" \
    && cd ../typescript-vim && git reset "$NVIM_TYPESCRIPT_VERSION_COMMIT" \
    && cd ../vim-tsx && git reset "$NVIM_TSX_VERSION_COMMIT"

WORKDIR /home/dev/src

