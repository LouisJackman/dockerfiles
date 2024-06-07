# syntax=docker/dockerfile:1.4.1

ARG REGISTRY

FROM ${REGISTRY}/nvim-config:0.0.3

ARG ASDF_VERSION=0.11.3

# Install fundamental development packages.
USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update

    # gcc and g++ are used by nvim-treesitter.
    #
    # bat, fd-find, and ripgrep are invaluable when used directly, but they are
    # also used indirectly by nvim-telescope.
    #
    # Python is installed so that a more full-featured scripting language than
    # shell is always available.
    apt-get install --yes --no-install-recommends \
        bat \
        cloc \
        curl \
        direnv \
        exa \
        fd-find \
        file \
        g++ \
        gcc \
        git \
        htop \
        ipython3 \
        less \
        make \
        man-db \
        manpages \
        manpages-dev \
        ncdu \
        patch \
        pipx \
        python3 \
        python3-distutils \
        python3-pip \
        python3-venv \
        ripgrep \
        tree \
        xz-utils

    rm -fr /var/lib/apt/lists/*
EOF
USER user

# https://starship.rs/guide#%F0%9F%9A%80-installation
RUN sh \
    -c "$(curl -fsSL https://starship.rs/install.sh)" \
    -- \
    --yes \
    --bin-dir ~/.local/bin


# https://asdf-vm.com/guide/getting-started.html#_3-install-asdf
RUN git clone --branch v"$ASDF_VERSION" https://github.com/asdf-vm/asdf.git ~/.asdf

# Setup a basic shell, borrowing Fedora's idea of a `.bashrc.d` that holds a
# collection of configuration files rather than just one. Combine with Debian's
# convention of numerically prefixing rc files to order their load order.
COPY --chown=user .bashrc /home/user/
COPY --chown=user .config/shrc.d/50-configure.sh /home/user/.config/shrc.d/

RUN ["mkdir", "-p", "/home/user/.config/direnv"]
COPY --chown=user .config/direnv/direnv.toml /home/user/.config/direnv/

# Ensure third party packages are installed for Neovim.
#
# `-c` runs after config, and the config knows how to bootstrap for the first
# time if certain expected files are missing. Therefore, this line bootstraps
# Neovim and then quits.
COPY --chown=user additional_setup.lua /home/user/.config/nvim/lua/user/
RUN nvim --headless -c quitall

# Copy across miscellaneous tools that ultimately derive from
# https://gitlab.com/louis.jackman/toolbag
COPY --chown=user toolbag /home/user/src/gitlab.com/louis.jackman/toolbag

RUN git config --global --add safe.directory /home/user/workspace

ENTRYPOINT ["bash"]
