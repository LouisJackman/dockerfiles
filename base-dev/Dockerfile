FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV NEOVIM_VERSION 0.4.3

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

RUN ["python3", "-m", "pip", "install", "pynvim"]

RUN ["mkdir", "-p", "/home/dev/.local/share/nvim/site/pack/default/start"]
WORKDIR /home/dev/.local/share/nvim/site/pack/default/start
RUN git clone https://github.com/Shougo/deoplete.nvim.git \
    && git clone https://github.com/airblade/vim-gitgutter \
    && git clone https://github.com/arcticicestudio/nord-vim \
    && git clone https://github.com/autozimu/LanguageClient-neovim \
    && git clone https://github.com/ctrlpvim/ctrlp.vim.git \
    && git clone https://github.com/dense-analysis/ale \
    && git clone https://github.com/honza/vim-snippets \
    && git clone https://github.com/majutsushi/tagbar \
    && git clone https://github.com/roxma/nvim-yarp.git \
    && git clone https://github.com/roxma/vim-hug-neovim-rpc \
    && git clone https://github.com/scrooloose/nerdtree.git \
    && git clone https://github.com/tpope/vim-fugitive \
    && git clone https://github.com/tpope/vim-surround \
    && git clone https://github.com/vim-airline/vim-airline

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

