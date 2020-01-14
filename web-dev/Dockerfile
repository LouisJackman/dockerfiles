FROM base-dev

# LTS Release
ENV NODE_VERSION 12.14.1

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
    && git clone https://github.com/MaxMEllon/vim-jsx-pretty \
    && git clone https://github.com/leafgarland/typescript-vim \
    && git clone https://github.com/ianks/vim-tsx

WORKDIR /home/dev/src

