#!/bin/bash

PROJECT_HOME=$1
script_dir="$(dirname "$(realpath "$0")")"

echo "🔑 Please enter your username (all lowercase):"
read username

IMAGE_NAME="isolated-git"
CONTAINER_NAME="$username-git"

KEYSTORE="$HOME/my-keystore/$username"
SSH_DIR="$KEYSTORE/.ssh"
GNUPG_DIR="$KEYSTORE/.gnupg"

mkdir -p "$SSH_DIR"
mkdir -p "$GNUPG_DIR"

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
    -v $SSH_DIR:"/root/.ssh" \
    -v $GNUPG_DIR:"/root/.gnupg" \
    -v "$PROJECT_HOME":"/projects" \
    --name "$CONTAINER_NAME" \
    "$IMAGE_NAME" \
    /bin/ash
fi

# Wait for a few seconds to ensure the container is up (optional)
sleep 5

echo "🔄 Setting up your GitHub account..."
docker exec -ti "$CONTAINER_NAME" \
/bin/ash -c "source /scripts/setup-git.sh"

echo "✅ Setup Complete !!"
