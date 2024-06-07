# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/base-dev:0.0.2

ARG GO_VERSION=1.21.6 \
    GO_DOC_VERSION=0.2.0 \
    \
    GO_ARM64_SHA256_SUM=e2e8aa88e1b5170a0d495d7d9c766af2b2b6c6925a8f8956d834ad6b4cacbd9a \
    GO_AMD64_SHA256_SUM=3f934f40ac360b9c01f616a9aa1796d227d8b0328bf64cb045c7b8c4ee9caea4

USER root

# Set with `-e` in environments with private Go modules on private git
# repositories.
ENV GOPRIVATE=


# For cgo, and also to resolve this issue:
# https://github.com/golang/go/issues/26988
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        gcc \
        libc-dev
    rm -fr /var/lib/apt/lists/*
EOF

WORKDIR /opt

RUN chown user:user /opt

USER user

RUN <<-EOF
    uname_m=$(uname -m)
    readonly uname_m

    case "$uname_m" in
        aarch64)
            go_arch=arm64
            go_sha256_sum="$GO_ARM64_SHA256_SUM"
            ;;
        x86_64)
            go_arch=amd64
            go_sha256_sum="$GO_AMD64_SHA256_SUM"
            ;;
        *)
            echo unsupported arch "$uname_m" >&2
            exit 1
            ;;
    esac
    readonly go_arch
    readonly go_sha256_sum

    curl -LSOfs "https://go.dev/dl/go${GO_VERSION}.linux-${go_arch}.tar.gz"
    echo "$go_sha256_sum go${GO_VERSION}.linux-${go_arch}.tar.gz" \
        | sha256sum --check
    tar -xzf "go${GO_VERSION}.linux-${go_arch}.tar.gz"
    rm "go${GO_VERSION}.linux-${go_arch}.tar.gz"
EOF

WORKDIR /home/user

ENV PATH=$PATH:/opt/go/bin:/home/user/go/bin

COPY --chown=user additional_setup.lua /home/user/.config/nvim/lua/user/
COPY --chown=user plugins.lua /home/user/.config/nvim/lua/user/plugins/go.lua

RUN go install -v "golang.org/x/tools/cmd/godoc@v$GO_DOC_VERSION"

RUN nvim --headless -c 'GoInstallBinaries' -c quitall

WORKDIR /home/user/workspace

