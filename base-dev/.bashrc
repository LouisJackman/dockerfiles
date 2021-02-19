#!/usr/bin/env bash

setup_bash() {
    umask 077

    export PS1='[\u@\h \W]\$ '

    PATH="$HOME/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:$PATH"
}

setup_editor() {
	alias vi=nvim
	alias vim=nvim

	export EDITOR=nvim
	export VISUAL=nvim
}

main() {
    setup_bash
    setup_editor

    unset -f setup_bash
    unset -f setup_editor
}

main
unset -f main

