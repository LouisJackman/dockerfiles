FROM base-dev

ENV GO_VER 1.13.1
ENV GO_SHA_SUM 94f874037b82ea5353f4061e543681a0e79657f787437974214629af8407d124

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

WORKDIR /home/dev/src

