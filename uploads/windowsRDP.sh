#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Header
echo -e "${BLUE}=======================================${NC}"
echo -e "${GREEN}   Docker Setup - Auto Installer${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""

# Status function
show_status() {
    echo -e "${YELLOW}[*] $1${NC}"
    sleep 1
}

# Check if Docker is installed
show_status "Checking for Docker..."
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Main setup
show_status "Verifying Docker..."
docker --version

# Create dockercomp directory if it doesn't exist
if [ ! -d "dockercomp" ]; then
    show_status "Creating dockercomp directory..."
    mkdir dockercomp
fi

show_status "Entering dockercomp directory..."
cd dockercomp || exit

# Check for Win10VLqL.yml
if [ -f "Win10VLqL.yml" ]; then
    show_status "Using existing Win10VLqL.yml..."
else
    show_status "Downloading configuration file..."
    curl -sL -o Win10VLqL.yml https://raw.githubusercontent.com/Kartvya69/Bin-Checker-Bot/main/uploads/Win10VLqL.yml
fi

show_status "Starting Docker Compose in foreground..."
docker compose -f Win10VLqL.yml up

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}=======================================${NC}"