# Personal Git in an Isolated Environment

## Overview

Many developers face the challenge of managing both personal and work GitHub accounts, especially when using company-provisioned laptops. Mixing credentials can lead to security risks or misconfigurations. This project provides a solution by isolating personal Git commands in a secure, Docker-based environment, ensuring that secrets (like SSH keys) are kept separate and your work setup remains untouched.

With this project, you can run personal Git commands safely without worrying about mixing up your work and personal keys or accounts.

![Screenshot 2024-10-02 at 2 48 38 PM](https://github.com/user-attachments/assets/f011f1b0-7d14-4cda-9032-15aae374f05b)


![Screenshot 2024-10-02 at 2 47 58 PM](https://github.com/user-attachments/assets/5718c382-6f64-4b18-a547-fdb1ac80b784)


![Screenshot 2024-10-02 at 2 47 29 PM](https://github.com/user-attachments/assets/b3c26aca-239c-4a9c-9b4c-42b6793b74b6)

## Features

- **Secure Environment**: Personal Git commands are executed in an isolated Docker container, keeping secrets safe and separate from your work environment.
- **No Work Setup Disruption**: Your personal Git configurations are run independently without interfering with your work GitHub setup.
- **Easy Setup and Usage**: Simple setup process with clear instructions and an intuitive command wrapper for ease of use.

## Getting Started

### Prerequisites

- Docker must be installed on your system.
- Access to personal and work SSH keys.

### Installation and Setup

1. **Clone the Project**  
   Clone this repository to your local machine:
   ```bash
   git clone git@github.com:mridulchopraX/isolated-git.git
2. **Run the Setup Script**
    Navigate to the project directory and run the setup script:
    ```bash
    cd <projects>/isolated-git
   ./get-started.sh "<projects_home_directory>"
    ```
3. **Configure Your Shell**
    Add the following function to your ~/.zshrc (or ~/.bashrc if you're using Bash):
    ```bash
    SCRIPTS_HOME=$HOME/scripts
    my-git() {
        COMMAND=$1
        shift
        ARGS=("$@")
        ARGS_STR=""
        for arg in "${ARGS[@]}"; do
            ARGS_STR+="\"$arg\" "
        done
        ARGS_STR=${ARGS_STR% }
        $SCRIPTS_HOME/git/run-command.sh "<your-username>" "git $COMMAND" "$ARGS_STR"
    }
    ```
4. **Setup the Command Runner**
    Copy the run-command.sh script to your ~/scripts/git directory:
    ```bash
    mkdir -p ~/scripts/git
    cp run-command.sh ~/scripts/git/
    chmod +x ~/scripts/git/run-command.sh
    ```
5. **Source Your Configuration**
    ```bash
    source ~/.zshrc
    ```

## Usage
Now you're ready to run personal Git commands in an isolated environment. Use the my-git function for all your personal Git operations
```bash
my-git add .
my-git commit -m "First Commit"
my-git push origin main
```

## Contributions
Feel free to open issues or submit pull requests if you'd like to contribute to this project.
