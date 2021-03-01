#!/bin/bash
set -e

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"
SCRIPT_NAME="$( basename "${BASH_SOURCE[0]%.*}" )"
BUILD_ROOT="$SCRIPT_ROOT/workspace-$SCRIPT_NAME"
DOCKER_TAG="$USER/cross-compiling-workshop-arm64"

docker_image_exists() { docker inspect $1 >/dev/null 2>/dev/null; }

mkdir -p "$BUILD_ROOT"

# load cross-platform cpu emulation support
if [ "`uname -m`" != "aarch64" ]; then
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    # reload nubuilder if arm64 emulation is not available on the current one
    if (docker buildx ls | grep nubuilder >/dev/null) && ! (docker buildx ls | grep nubuilder | grep arm64 >/dev/null); then
        docker buildx create --use --name nubuilderarm64
    fi
fi

mkdir -p "$BUILD_ROOT"

# build builder
docker_image_exists $DOCKER_TAG:builder || \
docker build \
    --progress plain \
    --platform linux/arm64 \
    --tag $DOCKER_TAG:builder \
    --target builder \
    "$SCRIPT_ROOT"

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
docker_image_exists $DOCKER_TAG:runtime || \
docker build \
    --progress plain \
    --platform linux/arm64 \
    --tag $DOCKER_TAG:runtime \
    --target runtime \
    "$SCRIPT_ROOT"

# run docker qemu
docker run -t \
    --user `id -u`:`id -g` -e HOME=/tmp \
    --volume "$SCRIPT_ROOT":"$SCRIPT_ROOT" \
    --workdir "$BUILD_ROOT" \
    $DOCKER_TAG:runtime \
    "$BUILD_ROOT/app" "$SCRIPT_ROOT/dhcp.pcapng"
