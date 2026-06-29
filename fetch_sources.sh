#!/bin/bash
set -euoE pipefail
trap ">&2 echo FAILED" ERR

cd $(dirname $0)

WORKDIR="$(pwd)"
PROJECTS="qtbase qtcharts qttools qtdeclarative"
QT_VERSION=6.11.1

fetch(){
    PROJECT=$1
    URL=$2
    TAG=$3
    
    cd "$WORKDIR"
    if [ -d "$PROJECT" ]; then
        >&2 echo "Skipping $PROJECT"
        return
    fi
    git clone "$URL" "$PROJECT" -b $TAG --depth=1
    cd "$PROJECT"
    git submodule update --init --recursive
    echo "$PROJECT fetched!"
}

fetch pyside-setup "https://code.qt.io/pyside/pyside-setup" $QT_VERSION&

for PROJECT in $PROJECTS; do
    fetch $PROJECT "https://github.com/qt/$PROJECT" $QT_VERSION &
done

fetch "Qt-Advanced-Docking-System" "github.com/githubuser0xFFFF/Qt-Advanced-Docking-System" master &

wait
