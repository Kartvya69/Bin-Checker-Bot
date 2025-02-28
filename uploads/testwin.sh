#!/bin/bash

# Script: One-Command Docker Compose Setup                      # Description: Automates Docker and Docker Compose setup, downloads the YAML file, and starts the container.
# Author: Your Name
# Version: 1.0
                                                                # Set colorful output for better aesthetics
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display a header
print_header() {
    echo -e "${BLUE}"
    echo "=============================================="
    echo " One-Command Docker Compose Setup "
    echo "=============================================="
    echo -e "${NC}"
}

# Function to display a success message
print_success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

# Function to display a warning message
print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Start the script
print_header

# Switch to root user
echo -e "${BLUE}[*] Switching to root user...${NC}"
sudo su <<EOF

# Update and install Docker and Docker Compose
echo -e "${BLUE}[*] Updating package list...${NC}"
sudo apt update

if command_exists docker && command_exists docker-compose; then
    print_success "Docker and Docker Compose are already installed."
else
    echo -e "${BLUE}[*] Installing Docker and Docker Compose...${NC}"
    sudo apt install -y docker.io docker-compose
    print_success "Docker and Docker Compose installed successfully."
fi

# Navigate to the working directory
WORKDIR="$HOME/dockercomp"
echo -e "${BLUE}[*] Setting up working directory at $WORKDIR...${NC}"
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit

# Download the YAML file from the provided URL
YAML_FILE="Win10VLqL.yml"
YAML_URL="https://bit.ly/windowsRDP"
echo -e "${BLUE}[*] Downloading $YAML_FILE from $YAML_URL...${NC}"
wget -O "$YAML_FILE" "$YAML_URL"
print_success "$YAML_FILE downloaded successfully."

# Display the contents of the YAML file
echo -e "${BLUE}[*] Displaying contents of $YAML_FILE...${NC}"
cat "$YAML_FILE"

# Start Docker Compose
echo -e "${BLUE}[*] Starting Docker Compose...${NC}"
sudo docker-compose -f "$YAML_FILE" up

EOF
