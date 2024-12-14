#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"
IMAGE_NAME="isolated-git"
CONTAINER_NAME="$username-git"
SSH_DIR="$script_dir/internal/$username/.ssh"
GNUPG_DIR="$script_dir/internal/$username/.gnupg"
PROJECT_HOME="$HOME/Documents/mridulchopraX"


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


if [ ! "$(docker ps -a -q -f name=^${CONTAINER_NAME}$)" ]; then
    echo "📦 Creating and starting container '$CONTAINER_NAME'..."
    docker run -dti \
    -v $SSH_DIR:"/root/.ssh" \
    -v $GNUPG_DIR:"/root/.gnupg" \
    -v "$PROJECT_HOME":"/projects" \
    --name "$CONTAINER_NAME" \
    "$IMAGE_NAME" \
    /bin/ash
elif [ ! "$(docker ps -q -f name=^${CONTAINER_NAME}$)" ]; then
    # Container exists but is not running
    echo "⚙️ Starting the existing container '$CONTAINER_NAME'."
    docker start "$CONTAINER_NAME"
fi



COMMAND_STR+="\"$COMMAND\" "

    # Call the script with the correct parameters
    # echo "<run-command> Command : $COMMAND_STR, ARGS : $ARGS_STR"

PROJECT=$(basename "$PWD")
COMMAND_RUNNER="scripts/command-runner.sh"

export DOCKER_CLI_HINTS=false

docker exec -ti "$CONTAINER_NAME" \
/bin/ash -c "$COMMAND_RUNNER $PROJECT $COMMAND_STR $ARGS_STR"