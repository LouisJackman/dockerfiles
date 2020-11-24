FROM base-dev

ENV TERRAFORM_VERSION=0.12.23

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends unzip \
    && rm -fr /var/lib/apt/lists/*

WORKDIR /opt

RUN chown dev:dev /opt

USER dev

RUN curl -LSOfs "https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

ENV PATH=$PATH:/opt


COPY --chown=dev:dev additional_plugins.vim /home/dev/.config/nvim/autoload/

RUN IS_INITIAL_NVIM_HEADLESS_INSTALL=1 nvim --headless +quitall

WORKDIR /home/dev/src

