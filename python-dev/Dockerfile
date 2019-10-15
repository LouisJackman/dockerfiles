FROM base-dev

USER root
RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends python3-venv \
    && rm -fr /var/lib/apt/lists/*

USER dev

