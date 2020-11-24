FROM base-dev

ENV URBIT_VERSION=0.10.4

USER root

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    ca-certificates \
    curl \
    file \
    tree \
    vim.tiny \
    && rm -fr /var/lib/apt/lists/*

USER dev
WORKDIR /home/dev

COPY --chown=dev:dev additional_plugins.vim /home/dev/.config/nvim/autoload/

RUN IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +quitall

# Taken from https://urbit.org/using/install/
RUN curl -O "https://bootstrap.urbit.org/urbit-v${URBIT_VERSION}-linux64.tgz" \
    && tar xzf "urbit-v${URBIT_VERSION}-linux64.tgz" \
    && rm "urbit-v${URBIT_VERSION}-linux64.tgz"

# TODO: bake the loading of the kernel pill into a layer to improve startup
# times. Dropping `-x` and echoing `| exit` into the process doesn't work.
RUN /home/dev/urbit-v${URBIT_VERSION}-linux64/urbit -t -x -F zod

CMD /home/dev/urbit-v${URBIT_VERSION}-linux64/urbit zod
EXPOSE 8080

