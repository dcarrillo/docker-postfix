#!/usr/bin/env bash

set -e

if [ x"$DEBUG" = xtrue ]; then
    set -x
fi

# shellcheck disable=SC2039
trap _catch_err ERR
trap _cleanup EXIT

LOCAL_DIR="$(cd "$(dirname "$0")" ; pwd -P)"
# shellcheck disable=SC1090
. "$LOCAL_DIR"/../conf.env

_catch_err()
{
    echo "Test FAILED"
}

_cleanup()
{
    echo "Cleaning up..."
    docker rm -f "${POSTFIX_VERSION}"_test > /dev/null 2>&1
}

echo "Running container to be tested..."
docker run --name "${POSTFIX_VERSION}"_test --rm \
           -e MY_ROOT_ALIAS=mail_receiver \
           -e MY_HOSTNAME=test_localhost \
           -e MY_DOMAIN=test_localhost \
           -e MY_NETWORKS=127.0.0.1 \
           -d "${DOCKER_IMAGE}":"${POSTFIX_VERSION}" > /dev/null

sleep 2

DOCKER_EXEC="docker exec -i ${POSTFIX_VERSION}_test"

echo "Preparing container to be tested..."
$DOCKER_EXEC sh -c "adduser -S mail_receiver -s /bin/bash"
$DOCKER_EXEC sh -c "apk -q add mailx"

## Test 1 check receiving at aliased account
echo "+++ Sending test mail to root user aliased as mail_receiver"
$DOCKER_EXEC sh -c "echo 'This is a test...' | mail -s 'Testing postfix configuration' root@test_localhost"
$DOCKER_EXEC sh -c "grep -q 'Subject: Testing postfix configuration' /var/spool/mail/mail_receiver"

## Test 2 check rsyslog is logging to stdout
echo "+++ Testing rsyslog is logging to stdout"
$DOCKER_EXEC sh -c "logger -t test 'testing logging...'"
docker logs "${POSTFIX_VERSION}"_test 2>/dev/null | tail -1 | grep -q 'testing logging...'

echo "All tests succeeded !"
