#!/bin/sh

#
# A script is used rather than a dockerfile to allow being configured on a host
# too. A base text editor is one of the few components that is awkward to run
# _solely_ from a container. It is assumed that Neovim is already installed on
# the host and that it merely needs to be configured.
#

set -o errexit
set -o nounset

PYNVIM_VERSION=0.4.1
PIP_WHEEL_VERSION=0.34.2

for cmd in curl python3 nvim git
do
    if ! command -v "$cmd" >/dev/null
    then
        echo Missing command "$cmd", exiting... >&2
        exit 1
    fi
done

PATH="$HOME/.local/bin:$PATH"

python3 -m pip install --user wheel=="$PIP_WHEEL_VERSION"
python3 -m pip install --user pynvim=="$PYNVIM_VERSION"

curl -Lfo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +UpdateRemotePlugins -c 'CocInstall -sync coc-dictionary coc-emoji coc-explorer coc-highlight coc-json coc-omni coc-pairs coc-snippets coc-tag coc-yaml' +quitall

