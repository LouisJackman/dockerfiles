FROM debian:bullseye-20210111-slim

ENV LANG=C.UTF-8

ENV YOUTUBE_DL_VERSION=2021.2.4.1

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        ffmpeg \
        flac \
        lame \
        opus-tools \
        python3-pip \
        ffmpeg2theora \
        webp \
        x264 \
        x265 \
    && rm -fr /var/lib/apt/lists/*

RUN ["useradd", "-m", "user"]

USER user

ENV PATH=$PATH:/home/user/.local/bin

RUN pip3 install --user youtube_dl=="$YOUTUBE_DL_VERSION"

RUN ["mkdir", "/home/user/work"]
VOLUME /home/user/work
WORKDIR /home/user/work

