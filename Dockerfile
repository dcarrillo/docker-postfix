FROM alpine:3.12


ARG ARG_POSTFIX_VERSION
ENV POSTFIX_VERSION $ARG_POSTFIX_VERSION

# hadolint ignore=DL3018
RUN apk add --no-cache \
    postfix=$POSTFIX_VERSION \
    rsyslog \
    runit

COPY service /etc/service
COPY entrypoint.sh /entrypoint.sh
COPY rsyslog.conf /etc/rsyslog.conf

ENTRYPOINT ["/entrypoint.sh"]
