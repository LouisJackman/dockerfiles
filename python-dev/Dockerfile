FROM base-dev

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends python3-venv \
    && rm -fr /var/lib/apt/lists/*

USER dev

