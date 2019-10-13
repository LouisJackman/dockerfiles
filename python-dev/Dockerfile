FROM base-dev

USER root
RUN apt-get --yes update \
    && apt-get --yes --no-install-recommends install \
        python3 \
        python3-pip \
        python3-venv \
    && rm -fr /var/lib/apt/lists/*

USER dev

