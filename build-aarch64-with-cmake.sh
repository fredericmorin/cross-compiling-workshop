#!/bin/bash
set -ex

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"
SCRIPT_NAME="$( basename "${BASH_SOURCE[0]%.*}" )"
ROOTFS_PATH="focal/current/ubuntu-focal-core-cloudimg-arm64-root.tar.gz"
ROOTFS_URL="https://partner-images.canonical.com/core/$ROOTFS_PATH"

BUILD_ROOT="$SCRIPT_ROOT/workspace-$SCRIPT_NAME"
mkdir -p "$BUILD_ROOT"

# download rootfs
mkdir -p "$SCRIPT_ROOT/download"
[ ! -e "$SCRIPT_ROOT/download/$(basename $ROOTFS_PATH)" ] && \
    wget "$ROOTFS_URL" -P "$SCRIPT_ROOT/download"

# extract rootfs
mkdir -p "$BUILD_ROOT/chroot"
[ ! -e "$BUILD_ROOT/chroot/bin/bash" ] && \
    tar -xf "$SCRIPT_ROOT/download/$(basename $ROOTFS_PATH)" -C "$BUILD_ROOT/chroot/" && \
    proot -q qemu-aarch64 -S "$BUILD_ROOT/chroot/" apt update

# install deps
[ ! -e "$BUILD_ROOT/chroot/usr/share/doc/libpcap-dev" ] && \
    proot -q qemu-aarch64 -S "$BUILD_ROOT/chroot/" apt install -y libpcap-dev

# compile
cmake \
    -DCMAKE_TOOLCHAIN_FILE="$SCRIPT_ROOT/app/cmake/aarch64-linux-gnu.toolchain.cmake" \
    -DCMAKE_SYSROOT="$BUILD_ROOT/chroot" \
    -DCMAKE_STAGING_PREFIX="$BUILD_ROOT/chroot" \
    -S "$SCRIPT_ROOT/app" -B "$BUILD_ROOT"
cmake --build "$BUILD_ROOT" --target all

# stop here if --run is not requested
[ "${1:-}" = "--run" ] || exit 0

# run in chroot with cpu emulation
set -x
proot -q qemu-aarch64 -R "$BUILD_ROOT/chroot/" -b "$SCRIPT_ROOT" "$BUILD_ROOT/app" "$SCRIPT_ROOT/dhcp.pcapng"
