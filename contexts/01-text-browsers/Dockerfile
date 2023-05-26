# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.1

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update

    # Emacs no-X is for testing eww.
    apt-get --yes --no-install-recommends install \
        bash-completion \
        elinks \
        emacs-nox \
        lynx \
        w3m

    rm -fr /var/lib/apt/lists/*
EOF
USER user

