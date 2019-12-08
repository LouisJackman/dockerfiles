FROM base-dev

USER root
RUN apt-get --yes update \
    && apt-get --yes --no-install-recommends install \
        lynx \
        w3m \
        \
        # For testing eww
        emacs-nox \
    && rm -fr /var/lib/apt/lists/*

USER dev

