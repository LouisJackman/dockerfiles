FROM base-dev

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
      ansible \
      openssh-client \
    && rm -fr /var/lib/apt/lists/*

USER dev
WORKDIR /home/dev/src

VOLUME /home/dev/.ssh

