#!/bin/bash
set -ex

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"
SCRIPT_NAME="$( basename "${BASH_SOURCE[0]%.*}" )"
BUILD_ROOT="$SCRIPT_ROOT/cmake-$SCRIPT_NAME"
DOCKER_TAG="$USER/cross-compiling-workshop-native"

mkdir -p "$BUILD_ROOT"

# build builder
cd "$SCRIPT_ROOT"
docker build \
    --progress plain \
    --tag $DOCKER_TAG:builder \
    --target builder \
    .

# compile using builder
docker run -t \
    --user `id -u`:`id -g` -e HOME=/tmp \
    --volume "$SCRIPT_ROOT":"$SCRIPT_ROOT" \
    --workdir "$BUILD_ROOT" \
    $DOCKER_TAG:builder \
    /bin/bash -c "cmake ../app && cmake --build . --target all"

# skip run if --no-run is provided
[ "${1:-}" = "--no-run" ] && exit 0

# build runtime
cd "$SCRIPT_ROOT"
docker build \
    --progress plain \
    --tag $DOCKER_TAG:runtime \
    --target runtime \
    .

# run docker qemu
docker run -t \
    --user `id -u`:`id -g` -e HOME=/tmp \
    --volume "$SCRIPT_ROOT":"$SCRIPT_ROOT" \
    --workdir "$BUILD_ROOT" \
    $DOCKER_TAG:runtime \
    "$BUILD_ROOT/app" "$SCRIPT_ROOT/dhcp.pcapng"
