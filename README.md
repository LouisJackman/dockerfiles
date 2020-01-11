# dockerfiles

Dockerfiles for apps and environments I use. Inspired by [Jezz Frazelle's
Dockerfiles repository](https://github.com/jessfraz/dockerfiles).

Some are stand-in replacement for executables but now within a restricted
container. Others are enviroments that start in a shell.

They are run locally, not being pushed anywhere. `base-dev` must therefore be
built locally before building dependent images. Thankfully, `build.sh` can do
all of this for you.

