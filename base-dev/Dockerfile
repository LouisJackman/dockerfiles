FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8

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
        vim-nox \
        zsh \
    && rm -fr /var/lib/apt/lists/*

RUN ["useradd", "-m", "dev"]
RUN ["chsh", "-s", "/usr/bin/zsh", "dev"]

USER dev

COPY --chown=dev .zshrc /home/dev/
COPY --chown=dev vimrc /home/dev/.vim/

RUN ["python3", "-m", "pip", "install", "pynvim"]

RUN ["mkdir", "-p", "/home/dev/.vim/pack/default/start"]
WORKDIR /home/dev/.vim/pack/default/start
RUN git clone https://github.com/Shougo/deoplete.nvim.git \
    && git clone https://github.com/airblade/vim-gitgutter \
    && git clone https://github.com/autozimu/LanguageClient-neovim \
    && git clone https://github.com/ctrlpvim/ctrlp.vim.git \
    && git clone https://github.com/dense-analysis/ale \
    && git clone https://github.com/honza/vim-snippets \
    && git clone https://github.com/majutsushi/tagbar \
    && git clone https://github.com/roxma/vim-hug-neovim-rpc \
    && git clone https://github.com/roxma/nvim-yarp.git \
    && git clone https://github.com/scrooloose/nerdtree.git \
    && git clone https://github.com/tpope/vim-fugitive \
    && git clone https://github.com/tpope/vim-surround \
    && git clone https://github.com/vim-airline/vim-airline \
    && git clone https://github.com/vim-airline/vim-airline-themes

WORKDIR LanguageClient-neovim
RUN ./install.sh

RUN ["mkdir", "/home/dev/src"]
VOLUME /home/dev/src
WORKDIR /home/dev/src

ENTRYPOINT ["/usr/bin/zsh"]

