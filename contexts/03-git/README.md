# git

A minimal development image with just git and a vanilla Neovim installation.
Just enough to be able to use git and comfortably write large commit messages.

This package is the parent of the `base-dev` image. It has far fewer third party
packages than its child, owing to it using only a vanilla Neovim installation
and not installing development packages other than git tooling. For that reason,
it's safer to expose your SSH and GPG keys for git operations to this container
than to `base-dev`.

