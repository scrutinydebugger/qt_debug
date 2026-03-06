#!/bin/bash
set -euoE pipefail 
trap ">&2 echo FAILED" ERR

cd $(dirname $0)

WORKDIR="$(pwd)"
QTPATHS="$WORKDIR/qt-install/bin/qtpaths6"
OUTFOLDER="${WORKDIR}/pyside6-whl"

cd pyside-setup

python3 setup.py build   --qtpaths="${QTPATHS}" \
                        --cmake=/usr/bin/cmake \
                        --ignore-git \
                        --debug \
                        --verbose-build \
                        --build-tests \
                        --parallel=8 \
                        --build-type=all \
                        --module-subset=Core,Gui,Widgets,Charts,OpenGL,OpenGLWidgets \
                        --standalone 

python3 create_wheels.py --build-dir=./build --no-examples
rm -rf "$OUTFOLDER"
cp -r dist "$OUTFOLDER"
