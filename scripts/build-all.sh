#!/bin/bash
set -e

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd -P )"
DOCKER_TAG="$USER/cross-compiling-workshop-ci"

# --clean option
[ "${1:-}" = "--clean" ] && rm -rf $PROJECT_ROOT/cmake-build-*

BUILDS=""
BUILDS="$BUILDS build-native-manual.sh"
BUILDS="$BUILDS build-native-cmake.sh"

for BUILD_SCRIPT in $BUILDS; do
    SCRIPT_NAME="$( basename "${BUILD_SCRIPT%.*}" )"

    { echo -e "\n\n#################################" \
            "\n### $SCRIPT_NAME" \
            "\n#################################\n\n"; } 2>/dev/null

    $PROJECT_ROOT/$BUILD_SCRIPT
done
