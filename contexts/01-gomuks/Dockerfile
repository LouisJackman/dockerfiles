# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.1

ARG GOMUKS_VERSION=0.3.0 \
    GOMUKS_ARM64_SHA256_SUM=02a303a669ffda68545896e8804c8ee3abd9775abbac26850268b136e3f17ed2 \
    GOMUKS_AMD64_SHA256_SUM=3e35b4ad0e3acbb634152a45dd6cdede8ec4da8659ec1b7c3f269a64f5dfeb56

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update --yes
    apt-get install --yes --no-install-recommends \
        bash-completion \
        curl
    rm -fr /var/lib/apt/lists/*

    update-ca-certificates
EOF
USER user

RUN <<-EOF
    uname_m=$(uname -m)
    readonly uname_m

    case "$uname_m" in
        aarch64)
            gomuks_arch=arm64
            gomuks_sha256_sum="$GOMUKS_ARM64_SHA256_SUM"
            ;;
        x86_64)
            gomuks_arch=amd64
            gomuks_sha256_sum="$GOMUKS_AMD64_SHA256_SUM"
            ;;
        *)
            echo unsupported arch "$uname_m" >&2
            exit 1
            ;;
    esac
    readonly gomuks_arch
    readonly gomuks_sha256_sum

    curl -LSOfs "https://github.com/tulir/gomuks/releases/download/v${GOMUKS_VERSION}/gomuks-linux-${gomuks_arch}"
    echo "$gomuks_sha256_sum gomuks-linux-${gomuks_arch}" \
        | sha256sum --check
    mkdir -p ~/.local/bin
    mv "gomuks-linux-${gomuks_arch}" ~/.local/bin/gomuks
    chmod +x ~/.local/bin/gomuks
EOF

USER root
RUN <<-EOF
    apt purge curl --yes
    apt autoremove --yes
    apt clean
EOF
USER user

RUN ["mkdir", "-p", "/home/user/.cache/gomuks"]
RUN ["mkdir", "-p", "/home/user/.config/gomuks"]
RUN ["mkdir", "-p", "/home/user/.local/share/gomuks"]
VOLUME /home/user/.cache/gomuks/
VOLUME /home/user/.config/gomuks/
VOLUME /home/user/.local/share/gomuks/

ENTRYPOINT ["/home/user/.local/bin/gomuks"]
