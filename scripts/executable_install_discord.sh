#!/bin/bash

# Script to find and install Discord .deb file from Downloads folder
# Usage: ./install_discord.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Discord .deb Installer${NC}"
echo "=================================="

# Get Downloads directory
DOWNLOADS_DIR="$HOME/Downloads"

echo "Searching for Discord .deb file in: $DOWNLOADS_DIR"

# Find Discord .deb file
DISCORD_DEB=$(find "$DOWNLOADS_DIR" -name "discord*.deb" -type f 2>/dev/null | head -1)

if [ -z "$DISCORD_DEB" ]; then
    echo -e "${RED}Error: No Discord .deb file found in $DOWNLOADS_DIR${NC}"
    echo "Please make sure you have downloaded Discord from https://discord.com/download"
    exit 1
fi

echo -e "${GREEN}Found Discord .deb file:${NC} $DISCORD_DEB"

# Get file info
FILE_SIZE=$(du -h "$DISCORD_DEB" | cut -f1)
echo "File size: $FILE_SIZE"

# Ask for confirmation
echo -e "\n${YELLOW}Do you want to install this Discord package? (y/N)${NC}"
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo -e "\n${GREEN}Installing Discord...${NC}"

# Check if running as root or if sudo is available
if [ "$EUID" -eq 0 ]; then
    # Running as root
    dpkg -i "$DISCORD_DEB"
    # Fix any dependency issues
    apt-get install -f -y
else
    # Not root, use sudo
    if ! command -v sudo &> /dev/null; then
        echo -e "${RED}Error: This script requires sudo privileges to install packages.${NC}"
        echo "Please run as root or install sudo."
        exit 1
    fi
    
    echo "Installing with sudo (you may be prompted for your password)..."
    sudo dpkg -i "$DISCORD_DEB"
    
    # Fix any dependency issues
    echo "Fixing any dependency issues..."
    sudo apt-get install -f -y
fi

echo -e "\n${GREEN}Discord installation completed successfully!${NC}"
echo "You can now launch Discord from your applications menu or by running 'discord' in the terminal."

# Optional: Ask if user wants to delete the .deb file
echo -e "\n${YELLOW}Do you want to delete the downloaded .deb file? (y/N)${NC}"
read -r delete_response

if [[ "$delete_response" =~ ^[Yy]$ ]]; then
    rm "$DISCORD_DEB"
    echo -e "${GREEN}Downloaded .deb file deleted.${NC}"
else
    echo "Downloaded .deb file kept at: $DISCORD_DEB"
fi

echo -e "\n${GREEN}Done!${NC}"