# dockerfiles

Dockerfiles for apps and environments I use. Inspired by [Jezz Frazelle's
Dockerfiles repository](https://github.com/jessfraz/dockerfiles).

Some are stand-in replacement for executables but now within a restricted
container. Others are enviroments that start in a shell.

They are built and run locally, not being pushed anywhere. `base-dev` must
therefore be built locally before building dependent images. Thankfully,
`build.sh` can do all of this for you. By default, it will skip images that
already exist. To build them regardless, pass `--rebuild` to the script.

## Official Mirror of the GitLab Repository

This repository is currently hosted [on
GitLab.com](https://gitlab.com/louis.jackman/dockerfiles). Official mirrors
exist on [SourceHut](https://git.sr.ht/~louisjackman/dockerfiles) and
[GitHub](https://github.com/LouisJackman/dockerfiles). At the moment, GitLab
is still the official hub for contributions such as PRs and issues.

## Security

Some of these Dockerfiles are not as locked down as much as they should be, such
as excessive use of `root` or too much trust on downloads from third party
servers. Furthermore, they don't do as good a job as they should at spelling out
the Docker arguments to use for the most restricted execution e.g.
`--read-only`.

So, review before you use, and PRs to address such issues are welcome.

