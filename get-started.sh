#!/bin/bash

PROJECT_HOME=$1
script_dir="$(dirname "$(realpath "$0")")"

echo "🔑 Please enter your username (all lowercase):"
read username

IMAGE_NAME="isolated-git"
CONTAINER_NAME="$username-git"
ssh_dir="$script_dir/internal/$username/.ssh"
gnupg_dir="$script_dir/internal/$username/.gnupg"

mkdir -p "$ssh_dir"

echo "🛠️ Building Docker Image..."
docker build -t "$IMAGE_NAME" .

# Check if the container exists
if [ "$(docker ps -a -q -f name=^${CONTAINER_NAME}$)" ]; then
    echo "🟢 Container '$CONTAINER_NAME' already exists."

    # Check if the container is running
    if [ "$(docker ps -q -f name=^${CONTAINER_NAME}$)" ]; then
        echo "🚀 Container '$CONTAINER_NAME' is already running."
    else
        echo "⚙️ Starting the existing container '$CONTAINER_NAME'."
        docker start "$CONTAINER_NAME"
    fi
else
    echo "📦 Creating and starting container '$CONTAINER_NAME'..."
    docker run -dti \
    -v "$ssh_dir":"/root/.ssh" \
    -v "$gnupg_dir":"/root/.gnupg" \
    -v "$PROJECT_HOME":"/projects" \
    --name "$CONTAINER_NAME" \
    "$IMAGE_NAME" \
    /bin/bash
fi

# Wait for a few seconds to ensure the container is up (optional)
sleep 5

echo "🔄 Setting up your GitHub account..."
docker exec -ti "$CONTAINER_NAME" \
bash -c "source /scripts/setup-git.sh"

echo "✅ Setup Complete !!"
