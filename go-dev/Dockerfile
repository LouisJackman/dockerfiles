FROM base-dev

ENV GO_VERSION 1.13.7
ENV GO_SHA_SUM b3dd4bd781a0271b33168e627f7f43886b4c5d1c794a4015abf34e99c6526ca3
ENV VIM_GO_VERSION v1.22

USER root

# For cgo, and also to resolve this issue:
# https://github.com/golang/go/issues/26988
RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends \
       gcc \
       libc-dev \
    && rm -fr /var/lib/apt/lists/*

WORKDIR /opt

RUN chown dev:dev /opt

USER dev

RUN curl -LSOs https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    && echo "$GO_SHA_SUM go${GO_VERSION}.linux-amd64.tar.gz" | sha256sum --check \
    && tar -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

ENV PATH $PATH:/opt/go/bin:/home/dev/go/bin

RUN ["go", "get", "-v", "golang.org/x/tools/cmd/godoc"]

WORKDIR /home/dev

RUN git \
    clone \
    --depth 1 \
    https://github.com/fatih/vim-go.git \
    /home/dev/.local/share/nvim/site/pack/default/start/vim-go \
    --branch "$VIM_GO_VERSION"

RUN [ \
    "nvim", \
    "-c", \
    "GoInstallBinaries", \
    "-c", \
    "quit" \
]

WORKDIR /home/dev/src

