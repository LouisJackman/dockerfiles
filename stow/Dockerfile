FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends stow \
    && rm -fr /var/lib/apt/lists/*

RUN ["useradd", "-m", "user"]
USER user

RUN ["mkdir", "/home/user/work"]
VOLUME /home/user/work
WORKDIR /home/user/work

ENTRYPOINT ["stow"]

