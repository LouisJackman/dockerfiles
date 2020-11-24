FROM base-dev

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --yes --no-install-recommends install \
        build-essential \
        clangd \
        gdb \
        manpages \
        manpages-dev \
        strace \
    && rm -fr /var/lib/apt/lists/*

USER dev

RUN IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +'CocInstall -sync coc-clangd' +quitall

