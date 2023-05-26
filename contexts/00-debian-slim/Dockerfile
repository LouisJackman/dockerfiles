# syntax=docker/dockerfile:1.4.1

FROM debian:bookworm-20230502-slim

# Modify this in case the default UID/GIDs cause permission problems when
# working inside bind-mounted volumes.
ARG USER_UID_GID=1000

SHELL ["/bin/bash", "-o", "errexit", "-o", "pipefail", "-o", "nounset", "-c"]

ENV LANG=C.UTF-8

RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        ca-certificates
    rm -fr /var/lib/apt/lists/*

    update-ca-certificates
EOF

RUN groupadd -g "$USER_UID_GID" user \
    && useradd --create-home --uid "$USER_UID_GID" --gid "$USER_UID_GID" user
USER user

RUN umask 077

RUN mkdir -p ~/.local/bin
ENV PATH=/home/user/.local/bin:$PATH

VOLUME /home/user/workspace
WORKDIR /home/user/workspace

