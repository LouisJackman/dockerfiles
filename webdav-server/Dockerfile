FROM debian:bullseye-20210111-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
            apache2-utils \
            nginx-full \
        && rm -fr /var/lib/apt/lists/*

ARG WEBDAV_PASS

RUN test -n "$WEBDAV_PASS" && { echo "$WEBDAV_PASS" | htpasswd -c -i /etc/nginx/.htpasswd user; }

RUN mkdir /var/webdav \
    && chown www-data:www-data /var/webdav \
    && chmod ug=rwx,o= /var/webdav

RUN rm /etc/nginx/sites-available/* \
    && rm /etc/nginx/sites-enabled/* \
    && ln -s \
        /etc/nginx/sites-available/webdav.conf \
        /etc/nginx/sites-enabled/webdav.conf

COPY nginx.conf /etc/nginx/sites-available/webdav.conf

VOLUME /etc/ssl/certs/webdav-server.crt
VOLUME /etc/ssl/private/webdav-server.key
VOLUME /etc/ssl/webdav-server-diffie-hellman-ephemeral-parameters.pem

VOLUME /var/webdav
EXPOSE 443
STOPSIGNAL SIGTERM

CMD ["-g", "daemon off;"]
ENTRYPOINT ["nginx"]

