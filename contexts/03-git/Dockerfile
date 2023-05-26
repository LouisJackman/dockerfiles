# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/nvim-config:0.0.1

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive

    apt-get update
    apt-get install --yes --no-install-recommends \
        git \
        git-lfs \
        gnupg \
        openssh-client
    rm -fr /var/lib/apt/lists/*
EOF
USER user

VOLUME /home/user/.ssh/
VOLUME /home/user/.gnupg/
VOLUME /home/user/.gitconfig
VOLUME /home/user/.config/gitignore

ENTRYPOINT ["bash"]

