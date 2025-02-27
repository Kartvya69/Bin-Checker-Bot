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
    echo "Docker is not installed. Please install Docker Desktop or Docker CLI first."
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

show_status "Starting Docker Compose..."
docker compose -f Win10VLqL.yml up -d

# Get the container name dynamically
show_status "Fetching container name..."
CONTAINER_NAME=$(docker compose ps -q | xargs docker inspect --format '{{.Name}}' | sed 's|^/||' | head -n 1)

if [ -z "$CONTAINER_NAME" ]; then
    echo "Error: No running container found. Check 'docker compose logs' for details."
    exit 1
fi

show_status "Accessing container shell ($CONTAINER_NAME)..."
docker exec -it "$CONTAINER_NAME" /bin/bash || docker exec -it "$CONTAINER_NAME" /bin/sh

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}=======================================${NC}"