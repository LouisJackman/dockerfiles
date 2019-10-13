FROM base-dev

ENV DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get --yes update \
    && apt-get --yes --no-install-recommends install \
        python3 \
        python3-pip \
    && rm -fr /var/lib/apt/lists/*

USER dev

