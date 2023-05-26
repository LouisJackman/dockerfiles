# base-dev

A complete base development image with a full Neovim configuration, complete
with many handy command-line tools. The Neovim configuration used [is on
GitLab](https://gitlab.com/louis.jackman/neovim-config). Additionally, Python is
installed to assist with ad hoc scripting tasks. [My toolbag
repository](https://gitlab.com/louis.jackman/toolbag) is there too, its programs
being available on `PATH`.

git in this container is for the sake of tooling e.g. git diff indicators in
Neovim; do not use git directly yourself. Doing so presumably requires an SSH
key or entering a HTTPS passphrase, and perhaps a GPG key for commit
verification. None of those should be exposed to an environment with so many
third party packages running. Use the underlying, more minimal `git` image for
that instead.

