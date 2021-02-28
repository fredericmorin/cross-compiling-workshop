#!/bin/bash
set -ex

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../.. >/dev/null 2>&1 && pwd -P )"
SCRIPT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"
DOCKER_TAG="$USER/cross-compiling-workshop-ci"

# build builder
docker build \
    --progress plain \
    --tag $DOCKER_TAG \
    --file $SCRIPT_ROOT/Dockerfile \
    --target ci \
    "$PROJECT_ROOT"

# run command
exec docker run -it \
    --user `id -u`:`id -g` -e HOME=/tmp \
    --volume "$PROJECT_ROOT":"$PROJECT_ROOT" \
    --workdir "$PROJECT_ROOT" \
    $DOCKER_TAG \
    "$@"
