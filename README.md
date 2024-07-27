# dockerfiles

 [![pipeline
 status](https://gitlab.com/louis.jackman/dockerfiles/badges/master/pipeline.svg)](https://gitlab.com/louis.jackman/dockerfiles/-/commits/master)

Dockerfiles for programs and development environments I use. Inspired by [Jessie
Frazelle's Dockerfiles repository](https://github.com/jessfraz/dockerfiles).
They make my development environments reproducible and isolated, attempting to
solve [the insecurities that often occur in development
environments](https://volatilethunk.com/posts/2018/08/25/syntax-highlighting-and-remote-code-execution-why-developers-are-an-easy-target/post.html).

**Clone recursively, as it relies on submodules**, i.e. use `git clone
--recursive https://gitlab.com/louis.jackman/dockerfiles.git` rather than just
`git clone https://gitlab.com/louis.jackman/dockerfiles.git`. **Python must be
installed, at least version 3.11**.

Several operations are available, including pulling all prebuilt
multiarchitecture images to your local registry, building them all from scratch
locally with additional customisations, and more. **Run `make help` to see the
available targets.**

### Official Mirror of the GitLab Repository

This repository is currently hosted [on
GitLab.com](https://gitlab.com/louis.jackman/dockerfiles). An official mirror
exists on [GitHub](https://github.com/LouisJackman/dockerfiles). GitLab is still
the official hub for contributions such as PRs and issues.

## Synopsis

**Some images are stand-in replacements for executables but now within a
restricted container. Others are enviroments that start a shell. The ones
suffixed with `-dev` are full development environments with a preconfigured
editor ([Neovim](https://neovim.io/)) and other preloaded development tools.**

The resulting images can be pulled from [GitLab's container
registry](https://gitlab.com/louis.jackman/dockerfiles/container_registry/). For
example, to run the base development image, try `docker run -it --rm
registry.gitlab.com/louis.jackman/dockerfiles/base-dev`. Version tags are used
but `latest` is also set for convenience.

The last path component of the tag is based off the directory structure of this
repository; to illustrate, the built image of the Dockerfile found within the
`contexts/04-go-dev` directory can be found at
`registry.gitlab.com/louis.jackman/dockerfiles/go-dev`. The `04-` within that
path is a numeric prefix to control build ordering, which is explained later in
this document.

To build all images locally for just the current architecture and load the
result into Docker, run `make`. Run `make publish` to emulate the same building
and pushing steps taken by the CI, building for all supported platforms and
publishing to the remote registry.

Alternatively, they can be built locally for just the current architecture and
pushed to a local registry. Run `make publish-locally` to do so against a local
registry at `localhost:5000`.

## Image-Building Technicalities

### BuildKit and `scripts/src/context_building.py`

The images must be built in a specific order, e.g. `debian-slim` before its
dependent images. `scripts/src/context_building.py` manages such dependencies
for us while building, and it's encapsulated behind a `make` invocation. This is
implemented using numeric ordering prefixes on the context directory, e.g.
`debian-slim` being prefixed with `00-` to represent it being in the first
batch of images to build, and its dependent image `base-dev` coming long
after it due to having a `03-` prefix.

The `publish-locally` make target also solves the problem of [BuildKit having
poor support for dependencies on images stored in the local Docker images
store](https://github.com/moby/buildkit/issues/2343) by relying on a local
registry instead.

### Multiarchiture Support, at Least for ARM64 and AMD64

They should work on both AMD64 and ARM64, but require a modern
BuildKit-supporting Docker installation and QEMU binaries for both
architectures.

### Setting up BuildKit and Using a Local Registry

To deploy to a local registry, first spin up a local Docker registry:

```sh
docker run -d -e REGISTRY_STORAGE_DELETE_ENABLED=true --restart=always --name registry -p 5000:5000 registry:2.8.3
```

This sets up a registry that auto-restarts when it ends and allows deletions
when necessary, and uses the expected 5000 port. For manipulating the registry
locally, such as listing and deleting images, consider [the `reg`
tool](https://github.com/genuinetools/reg).

**This spins up an unauthenticated registry without TLS, with the ability to
erase and replace images for anyone who can reach the port. This is only secure
if the port is firewalled for just localhost or the local network has other
mitigating controls.**

Then set up a builder instance:

```sh
docker buildx create --platform=linux/arm64,linux/amd64 --driver-opt=network=host --use
```

Doing it with these additional flags ensures it can cross-compile to both ARM64
and AMD64, while putting the builder on the host network. Without that
networking change, it can't see the registry service that was just spun up. A
more elegant solution would be to [give them both the same dedicated Docker
network](https://docs.docker.com/network/network-tutorial-standalone/#use-user-defined-bridge-networks).

Ensure the QEMU binaries for all desired platforms exist by invoking this
one-shot container. This may not work on all architectures, meaning some will
only be capable of doing "local" image builds rather than building for multiple
architectures.

```sh
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

Finally, build the images and push them to the local registry:

```sh
make publish-locally
```

See the `publish-locally` make target for more details.

## Security

Unlike other containerised development approaches, such as Fedora Silverblue's
`toolbox`, these containers discourage mounting your entire home directory.
Instead, the suggestion is to change into the project directory and invoke the
container from there using something like `docker run -it --rm -v
"$PWD:/home/user/workspace
registry.gitlab.com/louis.jackman/dockerfiles/base-dev`. (Definitely make a
shell alias for your favourite images.) That way, the blast radius of a
compromised environment is just that project and not your entire home directory
including your SSH and GPG keys.

Sure, Neovim and some basic tools like `git` may seem secure, but can you be
sure that [every third party Neovim package or language linter won't at some
point suffer from a supply chain
attack](https://eslint.org/blog/2018/07/postmortem-for-malicious-package-publishes/)?

That said, some of these Dockerfiles are not as locked down as much as they
should be. They extensively trust downloads from third-party servers.
Furthermore, they don't do as good a job as they should at spelling out the
Docker arguments to use for the most restricted execution e.g. `--read-only`.

So, review before you use, and PRs to address such issues are welcome.

## Development Environment Features

### Neovim Configuration

The `*-dev` images have a full Neovim setup including autocomplete and other
nicities expected for modern development environments. To see how this works,
see [my neovim-config
repository](https://gitlab.com/louis.jackman/neovim-config), which this depends
on.

### Toolbag

Some utility scripts are preloaded into the `*-dev` images. They exist in their
own [git repository](https://gitlab.com/louis.jackman/toolbag).

## Custom Local Builds with Additional Configuration

While prebuilt versions of these images exist, some environments may need some
additional configuration that necessitates building from scratch locally via
`make` or `make publish-locally`.

### Custom TLS Certificates

Some environments, such as more sensitive commercial networks, will require
custom TLS certificates to support technologies such as Data Loss Protection
(DLP) or endpoint protection.

To handle this, pull in the certificates via a `COPY` command. This examples
assumes the certificates were pulled in via another build layer called `certs`:

```dockerfile
COPY --from=certs ca-certificates/ /usr/local/share/ca-certificates/
```

This needs to be done in the Dockerfiles of all the top-most base images, i.e.
those starting with `00-`, near the start of the final layer. The distro of
choice will also need to be instructed to acknowledge the additions, such as
invoking `update-ca-certificates` in Debian-based distributions.

### Custom UID/GID to Avoid Bind-Mounting Permission Problems

Depending on the Docker client setup, the way the container environments
bind-mount the current working directory could fall afoul of permissions if the
client doesn't automatically resolve it for you.

This comes down to the UID of the Docker user and the default user account
inside the container not matching, meaning the bind-mounted working directory is
seen as being owned by a different user.

To resolve this, update the `ARG USER_UID_GID=...` line in the top-most base
images (those starting with `00-`) to refer to the UID/GID of your workstation's
user and rebuild the images locally.
