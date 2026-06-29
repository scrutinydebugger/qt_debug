#!/bin/bash
set -euoE pipefail 
trap ">&2 echo FAILED" ERR

cd $(dirname $0)

WORKDIR="$(pwd)"
QTPATHS="$WORKDIR/qt-install/bin/qtpaths6"
OUTFOLDER="${WORKDIR}/pyside6-whl"

cd pyside-setup

args=""
args+=" --qtpaths=${QTPATHS}"
args+=" --cmake=/usr/local/bin/cmake"
args+=" --debug"
#args+=" --log-level=verbose"
args+=" --no-qt-tools"
args+=" --build-tests"
args+=" --parallel=8"
args+=" --build-type=all"
args+=" --module-subset=Core,Gui,Widgets,Charts,OpenGL,OpenGLWidgets"
args+=" --standalone"

python3 setup.py build $args

python3 create_wheels.py --build-dir=./build --no-examples
rm -rf "$OUTFOLDER"
cp -r dist "$OUTFOLDER"
