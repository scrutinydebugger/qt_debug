FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp
RUN apt-get update && apt-get install -y    \
    git                                     \
    ninja-build                             \
    build-essential                         \
    libfontconfig1-dev                      \
    libfreetype-dev                         \
    libgtk-3-dev                            \
    libx11-dev                              \
    libx11-xcb-dev                          \
    libxcb-cursor-dev                       \
    libxcb-glx0-dev                         \
    libxcb-icccm4-dev                       \
    libxcb-image0-dev                       \
    libxcb-keysyms1-dev                     \
    libxcb-randr0-dev                       \
    libxcb-render-util0-dev                 \
    libxcb-shape0-dev                       \
    libxcb-shm0-dev                         \
    libxcb-sync-dev                         \
    libxcb-util-dev                         \
    libxcb-xfixes0-dev                      \
    libxcb-xkb-dev                          \
    libxcb1-dev                             \
    libxext-dev                             \
    libxfixes-dev                           \
    libxi-dev                               \
    libxkbcommon-dev                        \
    libxkbcommon-x11-dev                    \
    libxrender-dev                          \
    libzstd-dev                             \
    patchelf                                \
    libncurses5-dev                         \
    libgdbm-dev                             \
    libnss3-dev                             \
    libssl-dev                              \
    libreadline-dev                         \
    libffi-dev                              \
    zlib1g-dev                              \
    libsqlite3-dev                          \
    libglib2.0-dev                          \
    iproute2                                \
    ccache                                  \
    p7zip-full                              \
    wget                                    \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3-linux-x86_64.sh \
    && chmod +x cmake-3.29.3-linux-x86_64.sh \
    && ./cmake-3.29.3-linux-x86_64.sh --skip-license --prefix=/usr/local \
    && rm cmake-3.29.3-linux-x86_64.sh
    
ARG LIBCLANG_FILE="libclang-release_18.1.7-based-linux-Ubuntu22.04-gcc11.4-x86_64.7z"
RUN wget "https://download.qt.io/development_releases/prebuilt/libclang/${LIBCLANG_FILE}"   \
    && 7z x "${LIBCLANG_FILE}"                                                              \
    && rm "${LIBCLANG_FILE}"
ENV LLVM_INSTALL_DIR=/tmp/libclang

# ============================================
ARG PYTHON_VERSION="3.14.6"
ARG PYTHON_SRC="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"

RUN wget $PYTHON_SRC \
    && tar -xvzf "Python-${PYTHON_VERSION}.tgz" \
    && cd "Python-${PYTHON_VERSION}" \
    && ./configure --with-pydebug --enable-shared \
    && make -j 4 \
    && make altinstall \
    && cd .. \
    && rm "Python-${PYTHON_VERSION}.tgz" \
    && rm -rf "Python-${PYTHON_VERSION}"

ENV LD_LIBRARY_PATH=/usr/local/lib/
RUN python3.14 -m venv /tmp/venv

RUN /tmp/venv/bin/python -m pip --no-cache-dir install  \
    setuptools                                          \
    packaging                                           \
    wheel                                               \
    build                                               \
    --upgrade
