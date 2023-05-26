# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/nvim-build:0.0.1 as nvim-build


FROM ${REGISTRY}/debian-slim:0.0.1

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --yes --no-install-recommends \
        bash-completion \
        exuberant-ctags \
        git \
        xxd \
        xz-utils
    rm -fr /var/lib/apt/lists/*
EOF
USER user

RUN mkdir -p ~/.local/nvim

COPY --chown=user --from=nvim-build /home/user/nvim.tar.xz /home/user/.local/nvim/

RUN <<-EOF
    cd ~/.local/nvim
    tar -xJf nvim.tar.xz
    rm nvim.tar.xz
EOF

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get purge --yes git xz-utils
    apt-get autoremove --yes
    apt-get clean
EOF
USER user

ENV PATH=/home/user/.local/nvim/bin:$PATH \
    VISUAL=nvim \
    EDITOR=nvim

RUN mkdir -p ~/.config/nvim
COPY --chown=user neovim-config/init.lua /home/user/.config/nvim/init.lua
COPY --chown=user neovim-config/lazy-lock.json /home/user/.config/nvim/lazy-lock.json
COPY --chown=user neovim-config/lua /home/user/.config/nvim/lua
COPY --chown=user additional_setup.lua /home/user/.config/nvim/lua/user/additional_setup.lua

# `-c` runs after config, and the config knows how to bootstrap for the first
# time if certain expected files are missing. Therefore, this line bootstraps
# Neovim and then quits.
RUN nvim --headless -c quitall

ENTRYPOINT ["nvim"]
