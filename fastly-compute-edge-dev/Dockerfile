FROM rust-dev

ARG arch=amd64

# Fill this in to do any real work with Fastly's CLI.
ENV FASTLY_API_TOKEN

ENV FASTLY_CLI_VERSION=0.24.2
ENV FASTLY_CLI_SHA512_SUM=8121634bdae2e58acf7c9ab116ab9b59a905ee1bf446b4693b1c38089ebeb9a60e5c9d8db8108ec4ba325273060d7c6fac7f9d1abec93c52ab2f210ce1e0248d
ENV FASTLY_CLI_ARCH=$arch

USER root

WORKDIR /opt

RUN curl -LSfsO "https://github.com/fastly/cli/releases/download/v$FASTLY_CLI_VERSION/fastly_${FASTLY_CLI_VERSION}_linux_${FASTLY_CLI_ARCH}.deb"

RUN echo "$FASTLY_CLI_SHA512_SUM fastly_${FASTLY_CLI_VERSION}_linux_${FASTLY_CLI_ARCH}.deb" \
    | sha512sum -c -

RUN DEBIAN_FRONTEND=noninteractive apt install --yes "./fastly_${FASTLY_CLI_VERSION}_linux_${FASTLY_CLI_ARCH}.deb"

USER dev

RUN true && { echo && echo 'eval "$(fastly --completion-script-bash)"'; } >>~/.bashrc

