# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/node-dev:0.0.1

ARG OPENAPI_GENERATOR_CLI_VERSION=2.5.2 \
    STYLELINT_LSP_VERSION=1.2.4 \
    CREATE_NEXT_APP_VERSION=13.4.3

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update

    # openjdk-17-jre-headless is used by an OpenAPI specification generator
    # library which is later installed via npm.
    apt-get install --yes --no-install-recommends openjdk-17-jre-headless

    rm -fr /var/lib/apt/lists/*
EOF
USER user

RUN <<-EOF
    npm \
        install \
        --global \
        "@openapitools/openapi-generator-cli@$OPENAPI_GENERATOR_CLI_VERSION" \
        "stylelint-lsp@$STYLELINT_LSP_VERSION" \
        "create-next-app@$CREATE_NEXT_APP_VERSION"

    # openapi-generator-cli downloads content on the first run, so ensure that
    # data is based into the image.
    openapi-generator-cli version
EOF

