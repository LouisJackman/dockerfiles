#!/bin/sh

#
# A script is used rather than a dockerfile to allow being configured on a host
# too. A base text editor is one of the few components that is awkward to run
# _solely_ from a container. It is assumed that Neovim is already installed on
# the host and that it merely needs to be configured.
#

set -o errexit
set -o nounset

export PYNVIM_VERSION=0.4.1
export PIP_WHEEL_VERSION=0.34.2

export NVIM_DEOPLETE_VERSION_COMMIT=fb4a0436437999d245c5f747621352307ab073a0
export NVIM_LANGUAGE_CLIENT_VERSION=0.1.157
export NVIM_GIT_GUTTER_VERSION_COMMIT=c27bfab8c51e77419ee0c4a9c4e3ba359dbc2ad4
export NVIM_NORD_VIM_VERSION=v0.14.0
export NVIM_CTRL_P_VERSION=1.80
export NVIM_ALE_VERSION=v2.7.0
export NVIM_SNIPPETS_VERSION_COMMIT=900bf93c6680e38ce568dba26c3f48b4365ac730
export NVIM_TAGBAR_VERSION_COMMIT=d7063c7484f0f99bfa182b02defef7f412a9289c
export NVIM_NERDTREE_VERSION=6.9.0
export NVIM_FUGITIVE_VERSION=v3.2
export NVIM_SURROUND_VERSION_COMMIT=f51a26d3710629d031806305b6c8727189cd1935
export NVIM_AIRLINE_VERSION=v0.11

for cmd in python3 nvim git
do
    if ! command -v "$cmd"
    then
        echo Missing command "$cmd", exiting... >&2
        exit 1
    fi
done

PATH="$HOME/.local/bin:$PATH"

python3 -m pip install --user wheel=="$PIP_WHEEL_VERSION"
python3 -m pip install --user pynvim=="$PYNVIM_VERSION"

mkdir -p ~/.local/share/nvim/site/pack/default/start
cd ~/.local/share/nvim/site/pack/default/start

if [ -z "$(ls)" ]
then
    git clone https://github.com/Shougo/deoplete.nvim.git \
        && git clone https://github.com/airblade/vim-gitgutter \
        && git clone --depth 1 https://github.com/arcticicestudio/nord-vim --branch "$NVIM_NORD_VIM_VERSION" \
        && git clone --depth 1 https://github.com/autozimu/LanguageClient-neovim --branch "$NVIM_LANGUAGE_CLIENT_VERSION" \
        && git clone --depth 1 https://github.com/ctrlpvim/ctrlp.vim.git --branch "$NVIM_CTRL_P_VERSION" \
        && git clone --depth 1 https://github.com/dense-analysis/ale --branch "$NVIM_ALE_VERSION" \
        && git clone https://github.com/honza/vim-snippets \
        && git clone https://github.com/majutsushi/tagbar \
        && git clone --depth 1 https://github.com/preservim/nerdtree.git --branch "$NVIM_NERDTREE_VERSION" \
        && git clone --depth 1 https://github.com/tpope/vim-fugitive --branch "$NVIM_FUGITIVE_VERSION" \
        && git clone https://github.com/tpope/vim-surround \
        && git clone --depth 1 https://github.com/vim-airline/vim-airline --branch "$NVIM_AIRLINE_VERSION" \
        \
        && cd deoplete.nvim && git reset "$NVIM_DEOPLETE_VERSION_COMMIT" \
        && cd ../tagbar && git reset "$NVIM_TAGBAR_VERSION_COMMIT" \
        && cd ../vim-gitgutter && git reset "$NVIM_GIT_GUTTER_VERSION_COMMIT" \
        && cd ../vim-snippets && git reset "$NVIM_SNIPPETS_VERSION_COMMIT" \
        && cd ../vim-surround && git reset "$NVIM_SURROUND_VERSION_COMMIT" \
        && cd ..

    cd LanguageClient-neovim
    ./install.sh
fi

nvim -c UpdateRemotePlugins -c quit

