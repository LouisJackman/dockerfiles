#!/bin/sh

setup_aliases() {
    if command -v less >/dev/null
    then
        alias more=less
    fi

    # If it's missing, default it to true. A set falsy value disables the
    # alising of ls as exa.
    if [ -z "${DOCKERFILES_BASE_SCRIPT_ALIAS_LS_AS_EXA+x}" -o -n "$DOCKERFILES_BASE_SCRIPT_ALIAS_LS_AS_EXA" ]
    then
        alias ls=exa
    fi

    # If it's missing, default it to true. A set falsy value disables the
    # alising of batcat as cat.
    if [ -z "${DOCKERFILES_BASE_SCRIPT_ALIAS_CAT_AS_BATCAT+x}" -o -n "$DOCKERFILES_BASE_SCRIPT_ALIAS_CAT_AS_BATCAT" ]
    then
        alias cat=batcat
    fi
}

setup_sh() {
    umask 077

    # If it's missing, default it to true. A set falsy value disables the
    # starship.rs prompt.
    #
    # If starship isn't used, set a basic prompt for both login and non-login
    # shells.
    if [ -z "${DOCKERFILES_BASE_SCRIPT_INSTALL_STARSHIP+x}" -o -n "$DOCKERFILES_BASE_SCRIPT_INSTALL_STARSHIP" ]
    then
        # Sets up a fancy shell prompt.
        eval "$(starship init bash)"
    else
        if printf "%s" "$SHELL" | grep bash >/dev/null
        then
            export PS1='[\u@\h \W]\$ '
        else
            export PS1='[%n@%m %1d]$ '
        fi
    fi

    PATH="$PATH:/usr/local/sbin:/usr/local/bin"
}

setup_editor() {
    alias vi=nvim
    alias vim=nvim
}

setup_direnv() {
    eval "$(direnv hook bash)"
}

setup_asdf() {
    if [ -f ~/.asdf/asdf.sh ]
    then
        . ~/.asdf/asdf.sh
        source ~/.asdf/completions/asdf.bash
    fi
}

setup_toolbag() {
    if [ -d "$HOME"/src/gitlab.com/louis.jackman/toolbag ]
    then
        PATH="$PATH:$HOME/src/gitlab.com/louis.jackman/toolbag"
    fi
}

main() {
    setup_aliases
    setup_sh
    setup_editor
    setup_direnv
    setup_asdf
    setup_toolbag

    unset -f setup_aliases
    unset -f setup_sh
    unset -f setup_editor
    unset -f setup_direnv
    unset -f setup_asdf
    unset -f setup_toolbag
}

main
unset -f main

