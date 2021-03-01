#!/bin/bash
set -e

[ "${1:-}" = "--yes" ] || (
    echo "This script will completely wipe your local docker images repository. Add --yes to accept." >&2
    exit 1
)

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd -P )"

BUILDS=""
BUILDS="$BUILDS build-native-manual.sh"
BUILDS="$BUILDS build-native-cmake.sh"
BUILDS="$BUILDS build-native-with-docker.sh"
BUILDS="$BUILDS build-aarch64-with-cmake.sh"
BUILDS="$BUILDS build-aarch64-with-qemu.sh"
BUILDS="$BUILDS build-aarch64-with-docker.sh"

export TIMEFORMAT="%Rs"

echo -e "#  very first time"
echo
docker system prune --all --force >/dev/null
rm -rf $PROJECT_ROOT/workspace-build-*
for BUILD_SCRIPT in $BUILDS; do
    echo -ne "$BUILD_SCRIPT  \t"; time ($PROJECT_ROOT/$BUILD_SCRIPT 2>/dev/null >/dev/null)
done
echo

echo -e "#  post workspace clean"
echo
rm -rf $PROJECT_ROOT/workspace-build-*
for BUILD_SCRIPT in $BUILDS; do
    echo -ne "$BUILD_SCRIPT  \t"; time ($PROJECT_ROOT/$BUILD_SCRIPT 2>/dev/null >/dev/null)
done
echo

echo -e "#  build"
echo
for BUILD_SCRIPT in $BUILDS; do
    echo -ne "$BUILD_SCRIPT  \t"; time ($PROJECT_ROOT/$BUILD_SCRIPT 2>/dev/null >/dev/null)
done
