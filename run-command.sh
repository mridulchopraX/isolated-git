#!/bin/bash

CONTAINER_NAME="$1-git"
COMMAND=$2

current_dir=$(basename "$PWD")
project_dir="/projects/$current_dir"

export DOCKER_CLI_HINTS=false

docker exec -ti "$CONTAINER_NAME" \
bash -c "cd $project_dir && $COMMAND"