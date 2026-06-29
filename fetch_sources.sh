#!/bin/bash
set -euoE pipefail
trap ">&2 echo FAILED" ERR

cd $(dirname $0)

WORKDIR="$(pwd)"
PROJECTS="qtbase qtcharts qttools qtdeclarative"
VERSION=6.11.1

fetch(){
    PROJECT=$1
    
    cd "$WORKDIR"
    if [ -d "$PROJECT" ]; then
        >&2 echo "Skipping $PROJECT"
        continue
    fi
    git clone "https://github.com/qt/$PROJECT" -b $VERSION --depth=1
    cd "$PROJECT"
    git submodule update --init --recursive
    echo "$PROJECT fetched!"
}

git clone https://code.qt.io/pyside/pyside-setup -b $VERSION --depth 1 &

for PROJECT in $PROJECTS; do
    fetch "$PROJECT" &
done

wait
