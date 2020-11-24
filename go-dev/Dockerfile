FROM base-dev

ENV GO_VERSION=1.14
ENV GO_SHA_SUM=08df79b46b0adf498ea9f320a0f23d6ec59e9003660b4c9c1ce8e5e2c6f823ca

USER root

# For cgo, and also to resolve this issue:
# https://github.com/golang/go/issues/26988
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
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

ENV PATH=$PATH:/opt/go/bin:/home/dev/go/bin

COPY --chown=dev:dev additional_plugins.vim /home/dev/.config/nvim/autoload/

RUN ["go", "get", "-v", "golang.org/x/tools/cmd/godoc"]

WORKDIR /home/dev

RUN IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +'CocInstall -sync coc-go' +quitall

RUN [ \
    "nvim", \
    "-c", \
    "GoInstallBinaries", \
    "-c", \
    "quit" \
]

WORKDIR /home/dev/src

