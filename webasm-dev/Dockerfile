FROM base-dev

USER root
RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends clang cmake \
    && rm -fr /var/lib/apt/lists/*
USER dev

RUN [ \
    "git", \
    "clone", \
    "--recursive", \
    "https://github.com/WebAssembly/wabt", \
    "/home/dev/wabt" \
]

WORKDIR /home/dev/wabt
RUN ["make"]
ENV PATH $PATH:/home/dev/wabt/bin

WORKDIR /home/dev/src

