FROM alpine:3.11

RUN apk add --no-cache \
    postfix \
    rsyslog \
    runit

COPY service /etc/service
COPY entrypoint.sh /entrypoint.sh
COPY rsyslog.conf /etc/rsyslog.conf

ENTRYPOINT ["/entrypoint.sh"]
