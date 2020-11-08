FROM debian:buster-20201012-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends jq \
    && rm -fr /var/lib/apt/lists/*

RUN ["useradd", "-m", "user"]
USER user

ENTRYPOINT ["jq"]
CMD ["-C", "."]

