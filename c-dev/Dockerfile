FROM base-dev

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --yes --no-install-recommends install \
        build-essential \
        gdb \
        manpages \
        manpages-dev \
        strace \
    && rm -fr /var/lib/apt/lists/*

USER dev

