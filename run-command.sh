#!/bin/bash

CONTAINER_NAME="$1-git"
COMMAND=$2

shift 2;

ARGS=("$@") # This captures all arguments correctly
# Convert the array back to a single string with quotes
ARGS_STR=""
for arg in "${ARGS[@]}"; do
    ARGS_STR+=$arg
done
ARGS_STR=${ARGS_STR% } # Remove the trailing space


COMMAND_STR+="\"$COMMAND\" "

    # Call the script with the correct parameters
    # echo "<run-command> Command : $COMMAND_STR, ARGS : $ARGS_STR"

PROJECT=$(basename "$PWD")
COMMAND_RUNNER="scripts/command-runner.sh"

export DOCKER_CLI_HINTS=false

docker exec -ti "$CONTAINER_NAME" \
/bin/ash -c "$COMMAND_RUNNER $PROJECT $COMMAND_STR $ARGS_STR"