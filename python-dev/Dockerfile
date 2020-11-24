FROM base-dev

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends python3-venv \
    && rm -fr /var/lib/apt/lists/*

RUN ["pip3", "install", "jedi-language-server==0.21.0"]

USER dev

RUN IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +UpdateRemotePlugins +'CocInstall -sync coc-jedi' +quitall

