# Use a base image
FROM ubuntu:latest

# Set environment variables for non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory
WORKDIR /

# Copy your scripts into the 'scripts' directory
COPY ./internal/scripts/setup-git.sh ./scripts/
RUN chmod +x scripts/setup-git.sh
RUN mkdir /projects

# Install necessary packages
RUN apt-get update && apt-get install -y git gpg openssh-client

# Default command
CMD ["bash"]
