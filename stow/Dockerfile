FROM debian:buster-20201012-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends stow \
    && rm -fr /var/lib/apt/lists/*

RUN ["useradd", "-m", "user"]
USER user

RUN ["mkdir", "/home/user/work"]
VOLUME /home/user/work
WORKDIR /home/user/work

ENTRYPOINT ["stow"]

