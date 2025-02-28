#!/bin/bash

# Script: Windows Docker RDP Setup
# Description: Provides options for default setup, Ngrok with Docker, and Ngrok without Docker.
# Author: By kraters
# Version: 2.1

# Set colorful output for better aesthetics
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display a header
print_header() {
    echo -e "${BLUE}"
    echo "=============================================="
    echo " Windows Docker RDP Setup "
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

# Function for the default setup
default_setup() {
    echo -e "${BLUE}[*] Starting default Docker Compose setup...${NC}"
    sudo su <<EOF

    # Navigate to the working directory
    WORKDIR="$/dockercomp"
    echo -e "${BLUE}[*] Setting up working directory at $WORKDIR...${NC}"
    mkdir "$WORKDIR"
    cd "$WORKDIR" || exit

    # Download the YAML file from the provided URL
    YAML_FILE="Win10VLqL.yml"
    YAML_URL="https://raw.githubusercontent.com/Kartvya69/Bin-Checker-Bot/main/uploads/Win10VLqL.yml"
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
}

# Function for Ngrok with Docker
ngrok_with_docker() {
    echo -e "${BLUE}[*] Setting up Ngrok with Docker...${NC}"

    # Ask for Ngrok authtoken
    read -p "Enter your Ngrok authtoken: " NGROK_AUTHTOKEN
    if [[ -z "$NGROK_AUTHTOKEN" ]]; then
        print_warning "No authtoken provided. Exiting."
        exit 1
    fi

    # Ask for protocol (http or tcp)
    echo -e "${BLUE}[*] Choose a protocol:${NC}"
    echo "1) HTTP"
    echo "2) TCP"
    read -p "Enter your choice (1 or 2): " PROTOCOL_CHOICE

    case "$PROTOCOL_CHOICE" in
        1)
            PROTOCOL="http"
            read -p "Enter the port number for HTTP: " PORT
            ;;
        2)
            PROTOCOL="tcp"
            read -p "Enter the port number for TCP: " PORT
            ;;
        *)
            print_warning "Invalid choice. Exiting."
            exit 1
            ;;
    esac

    # Run Ngrok with Docker
    echo -e "${BLUE}[*] Starting Ngrok with Docker...${NC}"
    docker run --net=host -it -e NGROK_AUTHTOKEN="$NGROK_AUTHTOKEN" ngrok/ngrok:latest "$PROTOCOL" "$PORT"
}

# Function for Ngrok without Docker
ngrok_without_docker() {
    echo -e "${BLUE}[*] Setting up Ngrok without Docker...${NC}"

    # Install Ngrok
    echo -e "${BLUE}[*] Installing Ngrok...${NC}"
    curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
        | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
        && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
        | sudo tee /etc/apt/sources.list.d/ngrok.list \
        && sudo apt update \
        && sudo apt install -y ngrok

    # Ask for Ngrok authtoken
    read -p "Enter your Ngrok authtoken: " NGROK_AUTHTOKEN
    if [[ -z "$NGROK_AUTHTOKEN" ]]; then
        print_warning "No authtoken provided. Exiting."
        exit 1
    fi

    # Authenticate Ngrok
    echo -e "${BLUE}[*] Authenticating Ngrok...${NC}"
    ngrok config add-authtoken "$NGROK_AUTHTOKEN"

    # Instructions for the user
    echo -e "${GREEN}[✓] Ngrok setup complete. To run RDP, use the following command:${NC}"
    echo -e "${YELLOW}ngrok tcp 3389${NC}"
}

# Start the script
print_header

# Display options
echo -e "${BLUE}[*] Choose an option:${NC}"
echo "1) Default Docker Compose setup"
echo "2) Ngrok with Docker"
echo "3) Ngrok without Docker"
read -p "Enter your choice (1, 2, or 3): " CHOICE

case "$CHOICE" in
    1)
        default_setup
        ;;
    2)
        ngrok_with_docker
        ;;
    3)
        ngrok_without_docker
        ;;
    *)
        print_warning "Invalid choice. Exiting."
        exit 1
        ;;
esac
