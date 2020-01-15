FROM debian:buster-slim

USER root
RUN apt-get --yes update \
    && apt-get --yes --no-install-recommends install \
        elinks \
        lynx \
        w3m \
        \
        # For testing eww
        emacs-nox \
    && rm -fr /var/lib/apt/lists/*

USER dev

