# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.1

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        bash-completion \
        ffmpeg \
        flac \
        lame \
        opus-tools \
        python3-pip \
        webp \
        x264 \
        x265 \
        yt-dlp
    rm -fr /var/lib/apt/lists/*
EOF
USER user

