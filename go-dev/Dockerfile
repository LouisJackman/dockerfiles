FROM base-dev

ENV GO_VER 1.13.4
ENV GO_SHA_SUM 692d17071736f74be04a72a06dab9cac1cd759377bd85316e52b2227604c004c

# For cgo, and also to resolve this issue:
# https://github.com/golang/go/issues/26988
USER root
RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends \
       gcc \
       libc-dev \
    && rm -fr /var/lib/apt/lists/*
USER dev

WORKDIR /home/dev

RUN curl -LSOs https://dl.google.com/go/go${GO_VER}.linux-amd64.tar.gz \
    && echo "$GO_SHA_SUM go${GO_VER}.linux-amd64.tar.gz" | sha256sum --check \
    && tar -xzf go${GO_VER}.linux-amd64.tar.gz \
    && rm go${GO_VER}.linux-amd64.tar.gz

ENV PATH $PATH:/home/dev/go/bin

RUN [ \
    "git", \
    "clone", \
    "https://github.com/fatih/vim-go.git", \
    "/home/dev/.vim/pack/default/start/vim-go" \
]

RUN [ \
    "vim", \
    "-c", \
    "GoInstallBinaries", \
    "-c", \
    "quit" \
]

WORKDIR /home/dev/src

