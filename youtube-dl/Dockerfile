FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends python3-pip \
    && rm -fr /var/lib/apt/lists/*

RUN ["useradd", "-m", "user"]
USER user

RUN ["pip3", "install", "--user", "youtube_dl"]

RUN ["mkdir", "/home/user/downloads"]
VOLUME /home/user/downloads
WORKDIR /home/user/downloads

ENTRYPOINT ["/home/user/.local/bin/youtube-dl"]

