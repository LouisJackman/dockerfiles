FROM base-dev

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --yes --no-install-recommends install \
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
        manpages-dev \
        mtr \
        netcat-openbsd \
        nmap \
        openssh-client \
        openssl \
        subnetcalc \
        tcpdump \
        tshark \
    && rm -fr /var/lib/apt/lists/*

USER dev


