FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8

ENV NEOVIM_VERSION 0.4.3
ENV PYNVIM_VERSION 0.4.0
ENV PIP_WHEEL_VERSION 0.33.6

ENV NVIM_DEOPLETE_VERSION 5.1
ENV NVIM_LANGUAGE_CLIENT_VERSION 0.1.156
ENV NVIM_GIT_GUTTER_VERSION_COMMIT 9add23a492cba86df506db3be363c699f6c8d28e
ENV NVIM_NORD_VIM_VERSION v0.13.0
ENV NVIM_CTRL_P_VERSION 1.80
ENV NVIM_ALE_VERSION v2.6.0
ENV NVIM_SNIPPETS_VERSION_COMMIT 867f5cc995aec6c6f065d0ad76f5f0c914df4493
ENV NVIM_TAGBAR_VERSION v2.7
ENV NVIM_NERDTREE_VERSION 6.4.3
ENV NVIM_FUGITIVE_VERSION v3.1
ENV NVIM_SURROUND_VERSION_COMMIT f51a26d3710629d031806305b6c8727189cd1935
ENV NVIM_AIRLINE_VERSION v0.11

RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        git \
        make \
        tree \
        python3 \
        python3-pip \
        python3-setuptools \
        zsh \
    && rm -fr /var/lib/apt/lists/*

SHELL ["/usr/bin/zsh", "-c"]

WORKDIR /opt
RUN curl \
        -LSOfs \
        "https://github.com/neovim/neovim/releases/download/v$NEOVIM_VERSION/nvim-linux64.tar.gz" \
    && tar -xzf nvim-linux64.tar.gz \
    && rm nvim-linux64.tar.gz
ENV PATH "/opt/nvim-linux64/bin:$PATH"

RUN ["useradd", "-m", "dev"]
RUN ["chsh", "-s", "/usr/bin/zsh", "dev"]

USER dev

# Reduce shell configuration complexity by using zsh-style files exclusively.
RUN ["rm", "/home/dev/.bash_logout", "/home/dev/.bashrc", "/home/dev/.profile"]

COPY --chown=dev .zshrc /home/dev/
COPY --chown=dev init.vim /home/dev/.config/nvim/

ENV PATH "/home/dev/.local/bin:$PATH"
RUN python3 -m pip install --user wheel=="$PIP_WHEEL_VERSION" \
    && python3 -m pip install --user pynvim=="$PYNVIM_VERSION"

RUN ["mkdir", "-p", "/home/dev/.local/share/nvim/site/pack/default/start"]
WORKDIR /home/dev/.local/share/nvim/site/pack/default/start
RUN git clone --depth 1 https://github.com/Shougo/deoplete.nvim.git --branch "$NVIM_DEOPLETE_VERSION" \
    && git clone --depth 1 https://github.com/airblade/vim-gitgutter \
    && git clone https://github.com/arcticicestudio/nord-vim --branch "$NVIM_NORD_VIM_VERSION" \
    && git clone --depth 1 https://github.com/autozimu/LanguageClient-neovim --branch "$NVIM_LANGUAGE_CLIENT_VERSION" \
    && git clone --depth 1 https://github.com/ctrlpvim/ctrlp.vim.git --branch "$NVIM_CTRL_P_VERSION" \
    && git clone --depth 1 https://github.com/dense-analysis/ale --branch "$NVIM_ALE_VERSION" \
    && git clone https://github.com/honza/vim-snippets \
    && git clone --depth 1 https://github.com/majutsushi/tagbar --branch "$NVIM_TAGBAR_VERSION" \
    && git clone --depth 1 https://github.com/preservim/nerdtree.git --branch "$NVIM_NERDTREE_VERSION" \
    && git clone --depth 1 https://github.com/tpope/vim-fugitive --branch "$NVIM_FUGITIVE_VERSION" \
    && git clone https://github.com/tpope/vim-surround \
    && git clone --depth 1 https://github.com/vim-airline/vim-airline --branch "$NVIM_AIRLINE_VERSION" \
    \
    # Some Vim plugins have no release tags or very outdated latest versions.
    && cd vim-gitgutter && git reset "$NVIM_GIT_GUTTER_VERSION_COMMIT" \
    && cd ../vim-snippets && git reset "$NVIM_SNIPPETS_VERSION_COMMIT" \
    && cd ../vim-surround && git reset "$NVIM_SURROUND_VERSION_COMMIT"

WORKDIR LanguageClient-neovim
RUN ./install.sh

RUN [ \
    "nvim", \
    "-c", \
    "UpdateRemotePlugins", \
    "-c", \
    "quit" \
]

RUN ["mkdir", "/home/dev/src"]
VOLUME /home/dev/src
WORKDIR /home/dev/src

ENTRYPOINT ["/usr/bin/zsh"]

