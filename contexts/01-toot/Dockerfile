# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.1

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update --yes
    apt-get install --yes --no-install-recommends \
        bash-completion \
        toot
    rm -fr /var/lib/apt/lists/*

    update-ca-certificates
EOF
USER user

RUN ["mkdir", "-p", "/home/user/.config/toot"]
VOLUME /home/user/.config/toot/

ENTRYPOINT ["toot"]
CMD ["tui"]
