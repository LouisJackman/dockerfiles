# syntax=docker/dockerfile:1.4.1

ARG REGISTRY

FROM ${REGISTRY}/node-dev:0.0.2

ENV JOPLIN_VERSION=2.10.3

RUN npm \
        install \
        --global \
        "joplin@${JOPLIN_VERSION}"

COPY --chown=user additional_setup.lua /home/user/.config/nvim/lua/user/

VOLUME /home/user/.config/joplin

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["joplin"]
