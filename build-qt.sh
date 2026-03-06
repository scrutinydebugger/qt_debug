#!/bin/bash
set -euoE pipefail
trap ">&2 echo FAILED" ERR

cd "$(dirname $0)"
WORKDIR="$(pwd)"
QTBASE="$WORKDIR/qtbase"
QTCHARTS="$WORKDIR/qtcharts"
QTTOOLS="$WORKDIR/qttools"
QTDDECLARATIVE="$WORKDIR/qtdeclarative"
INSTALL_DIR="$WORKDIR/qt-install"


export CCACHE_DIR="$WORKDIR/.ccache"
mkdir -p "$CCACHE_DIR"

[ -d "$QTCHARTS" ] && mkdir -p "$QTCHARTS/build"
[ -d "$QTTOOLS" ] && mkdir -p "$QTTOOLS/build"
[ -d "$QTDDECLARATIVE" ] && mkdir -p "$QTDDECLARATIVE/build"

if [ ! -d "$QTBASE/build" ];  then
    mkdir "$QTBASE/build"
    cd "$QTBASE/build"
    "$QTBASE/configure" -debug -- -D CMAKE_CXX_COMPILER_LAUNCHER=ccache
fi

cd "$QTBASE/build"
cmake --build . --parallel
cmake --install . --prefix "${INSTALL_DIR}"


cd "$QTDDECLARATIVE/build"
cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/lib/cmake"  \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache            \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache              \
    ..

cmake --build . --parallel
cmake --install . --prefix "${INSTALL_DIR}"

cd "$QTTOOLS/build"
cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/lib/cmake"  \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache            \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache              \
    ..

cmake --build . --parallel
cmake --install . --prefix "${INSTALL_DIR}"


cd "$QTCHARTS/build"
cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/lib/cmake"  \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache            \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache              \
    ..
cmake --build . --parallel
cmake --install . --prefix "${INSTALL_DIR}"