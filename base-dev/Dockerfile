FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get --yes update \
    && apt-get --yes --no-install-recommends install \
        ca-certificates \
        curl \
        git \
        make \
        tree \
        vim-nox \
        zsh \
    && rm -fr /var/lib/apt/lists/*

RUN useradd -m dev
RUN ["chsh", "-s", "/usr/bin/zsh", "dev"]

COPY debian-default-zsh-config.zsh /home/dev/.zshrc
RUN ["chown", "dev:dev", "/home/dev/.zshrc"]

COPY vimrc /home/dev/.vim/vimrc
RUN ["chown", "-R", "dev:dev", "/home/dev/.vim"]

USER dev

RUN mkdir -p /home/dev/.vim/pack/default/start
WORKDIR /home/dev/.vim/pack/default/start
RUN git clone https://github.com/Shougo/deoplete.nvim.git \
    && git clone https://github.com/airblade/vim-gitgutter \
    && git clone https://github.com/autozimu/LanguageClient-neovim \
    && git clone https://github.com/ctrlpvim/ctrlp.vim.git \
    && git clone https://github.com/dense-analysis/ale \
    && git clone https://github.com/honza/vim-snippets \
    && git clone https://github.com/majutsushi/tagbar \
    && git clone https://github.com/roxma/vim-hug-neovim-rpc \
    && git clone https://github.com/scrooloose/nerdtree.git \
    && git clone https://github.com/tpope/vim-fugitive \
    && git clone https://github.com/tpope/vim-surround \
    && git clone https://github.com/vim-airline/vim-airline

WORKDIR LanguageClient-neovim
RUN ./install.sh

VOLUME /home/dev/src
WORKDIR /home/dev/src

ENTRYPOINT ["/usr/bin/zsh"]

