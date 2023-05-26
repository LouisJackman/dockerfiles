# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/git:0.0.1

ARG TERRAFORM_VERSION=1.3.3 \
    TERRAFORM_LS_VERSION=0.29.3 \
    TFSWITCH_VERSION=0.13.1288 \
    \
    TERRAFORM_LS_ARM64_SHA512_SUM=93a5cd152aeae5a31c1f7184b62dd644354eb9b9277f1d6b09ed91d5e7485414c5ec1274d95f8e76f2d649954e285d4bf60361cf1189df47df36d2d465c009ad \
    TERRAFORM_LS_AMD64_SHA512_SUM=043f4f8ec670c51cb4b21023b65dd08d387f2ee4392adceb3a11b83e9bd67210841950bc210084124f26bff4f1f32114d529de4d075bb79fff3753c1b192b708 \
    \
    TFSWITCH_ARM64_SHA512_SUM=c1f7c6afe22a3fb97668c2445bc0f00868c2b9cfd98e9423852931ab8bd8efbb811ea986e370f3d7599aec32d51b60003433cbae968c9d23093f847c55bce6a8 \
    TFSWITCH_AMD64_SHA512_SUM=7fca975175bab54285d9b1565bbc6e8c3c044533e4dad63ae912196d19e7700b8b7ca79321e901c42a2de2863a61d9c4d5f9965cfbd4b9fdc243f5e7aac91005

# Fill these in when starting the container to avoid the need to specify them
# per `aws` invocation. This comes at the cost of exposing them to everything
# inside the container, hence its minimalism.
ENV AWS_ACCESS_KEY_ID= \
    AWS_SECRET_ACCESS_KEY=

USER root
RUN <<-EOF
    DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        curl \
        gnupg \
        lsb-release \
        software-properties-common \
        unzip
    rm -fr /var/lib/apt/lists/*
EOF
USER user

COPY --chown=user .tfswitch.toml /home/user/

WORKDIR /home/user/.local/bin

RUN <<-EOF
    uname_m=$(uname -m)
    readonly uname_m

    case "$uname_m" in
        aarch64)
            terraform_arch=arm64
            terraform_ls_sha512_sum="$TERRAFORM_LS_ARM64_SHA512_SUM"
            tfswitch_sha512_sum="$TFSWITCH_ARM64_SHA512_SUM"
            ;;
        x86_64)
            terraform_arch=amd64
            terraform_ls_sha512_sum="$TERRAFORM_LS_AMD64_SHA512_SUM"
            tfswitch_sha512_sum="$TFSWITCH_AMD64_SHA512_SUM"
            ;;
        *)
            echo unsupported arch "$uname_m" >&2
            exit 1
            ;;
    esac
    readonly terraform_arch

    curl -LSOfs "https://releases.hashicorp.com/terraform-ls/$TERRAFORM_LS_VERSION/terraform-ls_${TERRAFORM_LS_VERSION}_linux_$terraform_arch.zip"
    echo "$terraform_ls_sha512_sum" "terraform-ls_${TERRAFORM_LS_VERSION}_linux_$terraform_arch.zip" \
        | sha512sum --check
    unzip "terraform-ls_${TERRAFORM_LS_VERSION}_linux_$terraform_arch.zip"
    rm "terraform-ls_${TERRAFORM_LS_VERSION}_linux_$terraform_arch.zip"

    mkdir "terraform-switcher_${TFSWITCH_VERSION}_linux_$terraform_arch"
    cd "terraform-switcher_${TFSWITCH_VERSION}_linux_$terraform_arch"
    curl -LSOfs "https://github.com/warrensbox/terraform-switcher/releases/download/$TFSWITCH_VERSION/terraform-switcher_${TFSWITCH_VERSION}_linux_$terraform_arch.tar.gz"
    echo "$tfswitch_sha512_sum" "terraform-switcher_${TFSWITCH_VERSION}_linux_$terraform_arch.tar.gz" \
        | sha512sum --check
    tar -xzf "terraform-switcher_${TFSWITCH_VERSION}_linux_$terraform_arch.tar.gz"
    mv tfswitch ..
    cd ..
    rm -r "terraform-switcher_${TFSWITCH_VERSION}_linux_$terraform_arch"

    tfswitch "$TERRAFORM_VERSION"
EOF

WORKDIR /home/user/workspace

