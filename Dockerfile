# Use a base image
FROM alpine:latest

# Set environment variables for non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory
WORKDIR /

# Copy your scripts into the 'scripts' directory
COPY ./internal/scripts/setup-git.sh ./scripts/
COPY ./internal/scripts/command-runner.sh ./scripts/
RUN chmod +x scripts/setup-git.sh
RUN chmod +x scripts/command-runner.sh
RUN mkdir /projects

# Install necessary packages
RUN apk update && apk add --no-cache git gnupg openssh

# Default command
CMD ["/bin/ash"]
