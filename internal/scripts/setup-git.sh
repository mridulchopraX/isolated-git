#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Prompt for username and email
echo -e "\033[34m"
echo "Enter your username : "
echo -e "\033[0m"
read username


echo -e "\033[34m"
echo "Enter your email : "
echo -e "\033[0m"
read email

# Generate SSH key
ssh-keygen -o -a 256 -t ed25519 -C "$email - $(date +'%m/%d/%Y')" -f ~/.ssh/id_ed25519.GitHub || { echo "SSH key generation failed"; exit 1; }

# Start SSH agent
echo 'eval "$(ssh-agent -s)"' >>~/.zprofile
eval "$(ssh-agent -s)"
ssh-add -k ~/.ssh/id_ed25519.GitHub

# Print SSH key with green color
echo -e "<<< PRINTING SSH KEY CONTENTS. PLEASE ADD TO YOUR GITHUB ACCOUNT >>>"
echo -e "\033[0;32m"  # Set text color to green
cat ~/.ssh/id_ed25519.GitHub.pub
echo -e "\033[0m"  # Reset text color to default

# Generate GPG key
gpg --quick-generate-key "$username (GitHub Signing Key) <$email>" future-default default 5y || { echo "GPG key generation failed"; exit 1; }

# Extract GPG key ID
key=$(gpg --list-secret-keys --keyid-format LONG | grep 'sec' | awk '{print $2}' | cut -d'/' -f2)
echo -e "\033[0;32m"
gpg --armor --export $key
echo -e "\033[0m"

# Configure SSH for GitHub
echo -e "Host GitHub\n    User git\n    Hostname github.com\n    IdentityFile ~/.ssh/id_ed25519.GitHub" >> ~/.ssh/config

# Set global Git configuration
git config --global user.signingkey $key
git config --global commit.gpgsign true
git config --global user.email $email

# Set up GPG TTY
export GPG_TTY=$(tty)

# Test GPG signing
echo "test" | gpg --clearsign
