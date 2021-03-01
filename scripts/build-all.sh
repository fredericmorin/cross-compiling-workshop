#!/bin/bash
set -e

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd -P )"
DOCKER_TAG="$USER/cross-compiling-workshop-ci"

# --clean option
[ "${1:-}" = "--clean" ] && rm -rf $PROJECT_ROOT/cmake-build-*

BUILDS=""
BUILDS="$BUILDS build-native-manual.sh"
BUILDS="$BUILDS build-native-cmake.sh"
BUILDS="$BUILDS build-native-with-docker.sh"

for BUILD_SCRIPT in $BUILDS; do
    { echo -e "\n\n#################################" \
            "\n### $BUILD_SCRIPT" \
            "\n#################################\n\n"; } 2>/dev/null

    time $PROJECT_ROOT/$BUILD_SCRIPT
done
