FROM base-dev

USER root
RUN apt-get --yes update \
    && apt-get --yes --no-install-recommends install \
        build-essential \
        gdb \
        manpages \
        manpages-dev \
        strace \
    && rm -fr /var/lib/apt/lists/*

USER dev

