#!/usr/bin/env sh

set -e

# shellcheck disable=SC1090
. "$(dirname "$0")"/conf.env

while [ $# -gt 0 ]; do
    case $1 in
        --push)
            PUSH=true
            shift
            ;;
        --latest)
            LATEST=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

docker build --build-arg=ARG_POSTFIX_VERSION="$POSTFIX_VERSION" \
             -t "$DOCKER_IMAGE":"$POSTFIX_VERSION" .

if [ x$PUSH = "xtrue" ]; then
    docker push "$DOCKER_IMAGE":"$POSTFIX_VERSION"
fi

if [ x$LATEST = "xtrue" ]; then
    docker tag "$DOCKER_IMAGE":"$POSTFIX_VERSION" "$DOCKER_IMAGE":latest
    [ x$PUSH = "xtrue" ] && docker push "$DOCKER_IMAGE":latest
fi
