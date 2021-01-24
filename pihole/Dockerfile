FROM pihole/pihole:v5.5.1

RUN ["ln", "-s", "/etc/lighttpd/conf-available/tls.conf", "/etc/lighttpd/conf-enabled/tls.conf"]

COPY tls.conf /etc/lighttpd/conf-available/

VOLUME /etc/ssl/private/pihole-server.pem

