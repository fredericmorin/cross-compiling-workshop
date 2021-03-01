#!/bin/bash
set -ex

SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"
SCRIPT_NAME="$( basename "${BASH_SOURCE[0]%.*}" )"
BUILD_ROOT="$SCRIPT_ROOT/workspace-$SCRIPT_NAME"

mkdir -p "$BUILD_ROOT"

# compile
g++ "$SCRIPT_ROOT/app/main.cpp" -lpcap -o "$BUILD_ROOT/app"

# skip run if --no-run is provided
[ "${1:-}" = "--no-run" ] && exit 0

"$BUILD_ROOT/app" "$SCRIPT_ROOT/dhcp.pcapng"
