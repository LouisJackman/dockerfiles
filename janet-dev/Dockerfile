FROM base-dev

USER root

RUN DEBIAN_FRONTEND=noninteractive apt-get update --yes \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    gcc \
    libc6-dev \
    git \
    make \
    && rm -fr /var/lib/apt/lists/*

WORKDIR /opt

RUN chown dev:dev /opt

USER dev

RUN git clone --depth 1 https://github.com/janet-lang/janet

WORKDIR /opt/janet

RUN ["make"]
RUN ["make", "test"]

USER root

RUN ["make", "install"]

USER dev

RUN IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +quitall

WORKDIR /home/dev/src

