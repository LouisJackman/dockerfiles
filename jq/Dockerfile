FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get --yes update \
    && apt-get install --yes --no-install-recommends jq \
    && rm -fr /var/lib/apt/lists/*

RUN ["useradd", "-m", "user"]
USER user

ENTRYPOINT ["jq"]
CMD ["-C", "."]

