FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8

RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends \
        ffmpeg \
        flac \
        lame \
        opus-tools \
        python3-pip \
        ffmpeg2theora \
        webp \
        x264 \
        x265 \
        zsh \
    && rm -fr /var/lib/apt/lists/*

RUN ["useradd", "-m", "user"]
RUN ["chsh", "-s", "/usr/bin/zsh", "user"]

USER user

ENV PATH $PATH:/home/user/.local/bin

RUN ["pip3", "install", "--user", "youtube_dl"]

RUN ["mkdir", "/home/user/work"]
VOLUME /home/user/work
WORKDIR /home/user/work

