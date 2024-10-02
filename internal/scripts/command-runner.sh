#!/bin/ash

# Capture the first two arguments separately
PROJECT=$1
COMMAND=$2

# Shift the first two arguments out
shift 2

ARGS_STR=""

# Loop through all remaining arguments
for arg in "$@"; do
    ARGS_STR="$ARGS_STR\"$arg\" " # Add quotes around each argument
done

# Remove the trailing space
ARGS_STR=${ARGS_STR% } # Remove the trailing space


# Remove the trailing space
ARGS_STR=${ARGS_STR% } # Remove the trailing space

# Correctly reference the PROJECT variable in uppercase
PROJECT_DIR="/projects/$PROJECT"

# Start the ssh-agent and add the SSH key
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add -k ~/.ssh/id_ed25519.GitHub > /dev/null 2>&1

# echo "<command-runner> COMMAND $COMMAND , ARGS $ARGS_STR" 

# Change to the project directory and execute the command
/bin/ash -c "cd \"$PROJECT_DIR\" && $COMMAND $ARG_STR"
