#!/bin/sh

# Source global definitions
if [ -f /etc/shrc ]
then
    . /etc/shrc
fi

# User specific environment
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# User specific aliases and functions
if [ -d ~/.config/shrc.d ]
then
    for rc in ~/.config/shrc.d/*
    do
        if [ -f "$rc" ]
        then
            . "$rc"
        fi
    done
fi
unset rc

