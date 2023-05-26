# pass-env

The `pass` command is provided an an environment image with a shell rather than
using `pass` directly as the top-level container process. This is because `pass`
isn't usually used interactively, but instead repeatedly invoked with provided
arguments.

Auto-completion of its commands is essential but cannot be handled by a `docker
run` alias, so put the user in a shell with such completion already set up and
`pass` on the `PATH`.

