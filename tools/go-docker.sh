#!/bin/sh

if [[ -f "${ENVIRONMENT}.env" ]]; then
    eval `${ENVIRONMENT}.env`
fi

POD_IMAGE=${POD_IMAGE:-"localhost/goro-go-dev:latest"}
POD_NAME=${POD_NAME:-"goro-go"}
POD_NETWORK=${POD_NETWORK:-""};
PORT=${PORT:-"8080"};
DEBUG_PORT=${DEBUG_PORT:-"42761"};

if docker pod exists "${POD_NAME}"; then
    docker pod rm "${POD_NAME}"
fi

mkdir -p .gocache

# Create the pod
args=( "pod" "create" "--name" "${POD_NAME}" );
[[ ! -z "${docker_NETWORK}" ]] && args+=( "--network" "${docker_NETWORK}" );
args+=( "-v" "$(pwd):/app/src" )
args+=( "-v" "$(pwd)/.gocache:/go" )
args+=( "-p" "${PORT}:${PORT}")
args+=( "-p" "${DEBUG_PORT}:${DEBUG_PORT}")
docker "${args[@]}"

# Run it
args=( "run" "-ti" "--pod" "${POD_NAME}" )
args+=( "-w" "/app/src" )
args+=( "${POD_IMAGE}" "/bin/bash" )
docker "${args[@]}"

# Ideally remove it
docker pod rm "${POD_NAME}"
