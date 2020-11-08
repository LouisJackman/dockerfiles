FROM base-dev

ENV TERRAFORM_VERSION=0.12.23
ENV VIM_TERRAFORM_VERSION_COMMIT=89c47c6c68f6260ba34ee0733437d863046fbe95

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

WORKDIR /home/dev/.local/share/nvim/site/pack/default/start
RUN git \
    clone \
    https://github.com/hashivim/vim-terraform.git \
    && cd vim-terraform \
    && git reset "$VIM_TERRAFORM_VERSION_COMMIT"

WORKDIR /home/dev/src

