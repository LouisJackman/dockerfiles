# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.1

ARG BOMBADILLO_VERSION=2.3.3 \
    BOMBADILLO_AMD64_SHA512_SUM=74ba1bcb63555cfd73496324cb8e3e41f4ba24fb0cab648411794e4ff6014c5c28d266bb1401fd4991814ff472d1542b52c9f598da766f78dfac1ca8577bbaf0 \
    BOMBADILLO_ARM_SHA512_SUM=5501784e7ea85a98056345d86159f222751f110d57a739bffbd79ecd5ca4430e44a92aff35caef012f82c2cab8474256bd817145453b7646f14d7ddfbb5eaf2e

USER root

RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update --yes
    apt-get install --yes --no-install-recommends \
        bash-completion \
        ca-certificates \
        curl \
        unzip
    rm -fr /var/lib/apt/lists/*
EOF

WORKDIR /opt

RUN <<-EOF
    uname_m=$(uname -m)
    readonly uname_m

    case "$uname_m" in
        aarch64)
            bombadillo_arch=arm
            bombadillo_sha512_sum="$BOMBADILLO_ARM_SHA512_SUM"
            ;;
        x86_64)
            bombadillo_arch=64
            bombadillo_sha512_sum="$BOMBADILLO_AMD64_SHA512_SUM"
            ;;
        *)
            echo "unsupported arch $uname_m" >&2
            exit 1
            ;;
    esac
    readonly bombadillo_arch
    readonly bombadillo_sha512_sum

    curl -OLf "https://bombadillo.colorfield.space/binaries/bombadillo-${BOMBADILLO_VERSION}_linux_${bombadillo_arch}.zip"
    echo "$bombadillo_sha512_sum bombadillo-${BOMBADILLO_VERSION}_linux_${bombadillo_arch}.zip" \
        | sha512sum -c -
    unzip "bombadillo-${BOMBADILLO_VERSION}_linux_${bombadillo_arch}.zip"
    mv bombadillo /usr/local/bin
    rm *
    chmod ugo+rx /usr/local/bin/bombadillo
EOF

USER user

ENTRYPOINT /usr/local/bin/bombadillo

