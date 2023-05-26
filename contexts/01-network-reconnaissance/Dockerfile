# syntax=docker/dockerfile:1.4.1

ARG REGISTRY


FROM ${REGISTRY}/debian-slim:0.0.1

USER root
RUN <<-EOF
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get --yes --no-install-recommends install \
        bash-completion \
        curl \
        dnsutils \
        htop \
        inetutils-ftp \
        inetutils-ping \
        inetutils-talk \
        inetutils-telnet \
        inetutils-tools \
        inetutils-traceroute \
        iperf3 \
        iproute2 \
        ipython3 \
        make \
        manpages-dev \
        mtr-tiny \
        netcat-openbsd \
        nmap \
        openssh-client \
        openssl \
        python3 \
        python3-pip \
        subnetcalc \
        tcpdump \
        tshark
    rm -fr /var/lib/apt/lists/*
EOF
USER user

