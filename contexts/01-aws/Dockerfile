# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.2

ARG AWS_VAULT_VERSION=6.6.0

# Fill these in when starting the container to avoid the need to specify them
# per `aws` invocation. This comes at the cost of exposing them to everything
# inside the container, hence its minimalism.
ENV AWS_ACCESS_KEY_ID='' \
    AWS_SECRET_ACCESS_KEY=''

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        awscli \
        bash-completion \
        curl
    rm -fr /var/lib/apt/lists/*
EOF
USER user

RUN <<-EOF
    uname_m=$(uname -m)
    readonly uname_m

    case "$uname_m" in
        aarch64)
            aws_vault_arch=arm64
            ;;
        x86_64)
            aws_vault_arch=amd64
            ;;
        *)
            echo unsupported arch "$uname_m" >&2
            exit 1
            ;;
    esac
    readonly aws_vault_arch

    curl -LSfs \
        -o ~/.local/bin/aws-vault \
        "https://github.com/99designs/aws-vault/releases/download/v$AWS_VAULT_VERSION/aws-vault-linux-$aws_vault_arch"
    chmod ug+rx ~/.local/bin/aws-vault
EOF

