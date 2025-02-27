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

# Check for root
if [ "$EUID" -ne 0 ]; then
    show_status "This script requires root privileges..."
    if ! sudo -n true 2>/dev/null; then
        echo "Please run with sudo or as root."
        exit 1
    fi
fi

# Main setup
show_status "Updating package lists..."
sudo apt update -y

show_status "Installing Docker and Docker Compose..."
sudo apt install -y docker.io docker-compose

show_status "Verifying Docker..."
docker --version

if [ ! -d "dockercomp" ]; then
    show_status "Creating dockercomp directory..."
    mkdir dockercomp
fi

show_status "Entering dockercomp directory..."
cd dockercomp || exit

if [ -f "Win10VLqL.yml" ]; then
    show_status "Using existing Win10VLqL.yml..."
else
    show_status "Downloading configuration file..."
    wget -q -O Win10VLqL.yml https://raw.githubusercontent.com/Kartvya69/Bin-Checker-Bot/main/uploads/Win10VLqL.yml
fi

show_status "Starting Docker Compose..."
sudo docker-compose -f Win10VLqL.yml up -d

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}=======================================${NC}"