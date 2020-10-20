FROM base-dev

ENV JANET_VIM_VERSION_COMMIT 1d616c0169138a017f245c104565bd25b079c8f0

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

# Always pull latest master with full history.
RUN git clone --depth 1 https://github.com/janet-lang/janet

WORKDIR /opt/janet

RUN ["make"]
RUN ["make", "test"]

USER root

RUN ["make", "install"]

USER dev

WORKDIR /home/dev

RUN git clone \
    --depth 1 \
    https://github.com/janet-lang/janet.vim \
    /home/dev/.local/share/nvim/site/pack/default/start/janet.vim \
    && cd /home/dev/.local/share/nvim/site/pack/default/start/janet.vim \
    && git reset "$JANET_VIM_VERSION_COMMIT"

WORKDIR /home/dev/src

