FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp
RUN apt-get update && apt-get install -y    \
    git                                     \
    cmake                                   \
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
    python3                                 \
    python3-pip                             \
    python3-venv                            \
    python3-dev                             \
    ccache                                  \
    p7zip-full                              \
    wget                                    \
    && rm -rf /var/lib/apt/lists/*

    
ARG LIBCLANG_FILE="libclang-release_18.1.7-based-linux-Ubuntu22.04-gcc11.4-x86_64.7z"
RUN wget "https://download.qt.io/development_releases/prebuilt/libclang/${LIBCLANG_FILE}"   \
    && 7z x "${LIBCLANG_FILE}"                                                              \
    && rm "${LIBCLANG_FILE}"
ENV LLVM_INSTALL_DIR=/tmp/libclang

RUN python3 -m venv /tmp/venv

RUN /tmp/venv/bin/python -m pip --no-cache-dir install  \
    setuptools                                          \
    packaging                                           \
    wheel                                               \
    build                                               \
    --upgrade
