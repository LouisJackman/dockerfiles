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
export PIP_WHEEL_VERSION=0.33.6

export NVIM_DEOPLETE_VERSION_COMMIT=08582f7c52aa53d63f9a7a714fab9137d6ea48f0
export NVIM_LANGUAGE_CLIENT_VERSION=0.1.156
export NVIM_GIT_GUTTER_VERSION_COMMIT=9add23a492cba86df506db3be363c699f6c8d28e
export NVIM_NORD_VIM_VERSION=v0.13.0
export NVIM_CTRL_P_VERSION=1.80
export NVIM_ALE_VERSION=v2.6.0
export NVIM_SNIPPETS_VERSION_COMMIT=867f5cc995aec6c6f065d0ad76f5f0c914df4493
export NVIM_TAGBAR_VERSION=v2.7
export NVIM_NERDTREE_VERSION=6.4.3
export NVIM_FUGITIVE_VERSION=v3.1
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
        && git clone --depth 1 https://github.com/majutsushi/tagbar --branch "$NVIM_TAGBAR_VERSION" \
        && git clone --depth 1 https://github.com/preservim/nerdtree.git --branch "$NVIM_NERDTREE_VERSION" \
        && git clone --depth 1 https://github.com/tpope/vim-fugitive --branch "$NVIM_FUGITIVE_VERSION" \
        && git clone https://github.com/tpope/vim-surround \
        && git clone --depth 1 https://github.com/vim-airline/vim-airline --branch "$NVIM_AIRLINE_VERSION" \
        \
        && cd deoplete.nvim && git reset "$NVIM_DEOPLETE_VERSION_COMMIT" \
        && cd ../vim-gitgutter && git reset "$NVIM_GIT_GUTTER_VERSION_COMMIT" \
        && cd ../vim-snippets && git reset "$NVIM_SNIPPETS_VERSION_COMMIT" \
        && cd ../vim-surround && git reset "$NVIM_SURROUND_VERSION_COMMIT" \
        && cd ..

    cd LanguageClient-neovim
    ./install.sh
fi

nvim -c UpdateRemotePlugins -c quit

