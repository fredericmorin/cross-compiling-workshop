#!/bin/bash
set -ex

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"
SCRIPT_NAME="$( basename "${BASH_SOURCE[0]%.*}" )"
BUILD_ROOT="$SCRIPT_ROOT/workspace-$SCRIPT_NAME"
DOCKER_TAG="$USER/cross-compiling-workshop-native-arm64-builder"

docker_image_exists() { docker inspect $1 >/dev/null 2>/dev/null; }

mkdir -p "$BUILD_ROOT"

# build image
docker_image_exists $DOCKER_TAG || \
docker build \
    --progress plain \
    --tag $DOCKER_TAG \
    --file Dockerfile.native-ubuntu20-aarch64-builder \
    "$SCRIPT_ROOT"

# compile using builder
cat <<EOF > "$BUILD_ROOT/build.sh"
#!/bin/bash -ex
cmake \
    -DCMAKE_TOOLCHAIN_FILE="$SCRIPT_ROOT/app/cmake/aarch64-linux-gnu.toolchain.cmake" \
    -DCMAKE_SYSROOT="/chroot-armv8-a" \
    -S "$SCRIPT_ROOT/app" -B "$BUILD_ROOT"
cmake --build "$BUILD_ROOT" --target all
EOF
chmod +x "$BUILD_ROOT/build.sh"
docker run -t --rm \
    --user `id -u`:`id -g` -e HOME=/tmp \
    --volume "$SCRIPT_ROOT":"$SCRIPT_ROOT" \
    --workdir "$BUILD_ROOT" \
    $DOCKER_TAG \
    "$BUILD_ROOT/build.sh"

# skip run if --no-run is provided
[ "${1:-}" = "--no-run" ] && exit 0

# run
docker run -it --rm \
    --user `id -u`:`id -g` -e HOME=/tmp \
    --volume "$SCRIPT_ROOT":"$SCRIPT_ROOT" \
    --workdir "$BUILD_ROOT" \
    $DOCKER_TAG \
    proot -q qemu-aarch64 -R "/chroot-armv8-a" -b "$SCRIPT_ROOT" "$BUILD_ROOT/app" "$SCRIPT_ROOT/dhcp.pcapng"
