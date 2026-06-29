#!/bin/bash
set -euoE pipefail
trap ">&2 echo FAILED" ERR

cd "$(dirname $0)"
WORKDIR="$(pwd)"
ADS_DIR="$WORKDIR/Qt-Advanced-Docking-System"
QT_INSTALL_DIR="$WORKDIR/qt-install"
INSTALL_DIR="$WORKDIR/qt-ads-install"

export CCACHE_DIR="$WORKDIR/.ccache"
mkdir -p "$CCACHE_DIR"

# ADS needs Qt private headers (qpa/...) which live under the versioned path.
# Qt6Gui_PRIVATE_INCLUDE_DIRS is only set when Qt6::GuiPrivate is found, but
# ADS never requests that component, so we inject the paths manually.
QT_VERSION=$(ls -d "${QT_INSTALL_DIR}/include/QtCore"/[0-9]* 2>/dev/null | head -1 | xargs basename)
PRIVATE_FLAGS="-isystem ${QT_INSTALL_DIR}/include/QtCore/${QT_VERSION}/QtCore"
PRIVATE_FLAGS+=" -isystem ${QT_INSTALL_DIR}/include/QtGui/${QT_VERSION}/QtGui"

if [ ! -d "$ADS_DIR/build" ]; then
    mkdir "$ADS_DIR/build"
    cd "$ADS_DIR/build"
    cmake -G Ninja \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_PREFIX_PATH="${QT_INSTALL_DIR}/lib/cmake" \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache \
        -DBUILD_EXAMPLES=OFF \
        "-DCMAKE_CXX_FLAGS=${PRIVATE_FLAGS}" \
        ..
fi

cd "$ADS_DIR/build"
cmake --build . --parallel
cmake --install . --prefix "${INSTALL_DIR}"
