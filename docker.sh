#!/bin/bash
set -euoE pipefail
trap ">&2 echo FAILED;" ERR

cd "$(dirname $0)"
WORKDIR="$(pwd)"
docker run                          \
    --volume $WORKDIR:$WORKDIR      \
    -w $WORKDIR                     \
    -u $(id -u):$(id -g)            \
    qtbuild                         \
    bash -c 'source /tmp/venv/bin/activate; exec "$@"' -- "$@"