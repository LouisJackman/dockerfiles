FROM base-dev

ENV URBIT_VERSION=0.10.4
ENV HOON_VIM_VERSION=116f29971a2fbec8e484daeba8afd9d60f85800f

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

# Taken from https://urbit.org/using/install/
RUN curl -O "https://bootstrap.urbit.org/urbit-v${URBIT_VERSION}-linux64.tgz" \
    && tar xzf "urbit-v${URBIT_VERSION}-linux64.tgz" \
    && rm "urbit-v${URBIT_VERSION}-linux64.tgz"

RUN git clone \
    https://github.com/urbit/hoon.vim \
    /home/dev/.local/share/nvim/site/pack/default/start/hoon.vim \
    && cd /home/dev/.local/share/nvim/site/pack/default/start/hoon.vim \
    && git reset "$HOON_VIM_VERSION"

# TODO: bake the loading of the kernel pill into a layer to improve startup
# times. Dropping `-x` and echoing `| exit` into the process doesn't work.
RUN /home/dev/urbit-v${URBIT_VERSION}-linux64/urbit -t -x -F zod

CMD /home/dev/urbit-v${URBIT_VERSION}-linux64/urbit zod
EXPOSE 8080

