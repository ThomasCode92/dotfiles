#!/bin/sh

cd ~/Downloads

# Postman CLI
curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | sh
sudo snap install postman

# Download the Discord .deb package
wget https://discord.com/api/download?platform=linux&format=deb
sudo dpkg -i download?platform=linux

# Joplin
sudo add-apt-repository universe
sudo apt install libfuse2
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash


# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# apt packages
sudo apt update && sudo apt upgrade
sudo apt install htop
sudo apt install age
sudo apt install build-essential
sudo apt install python3.10-venv

# snap packages
sudo snap install slack
sudo snap install bluemail
sudo snap install teams-for-linux
sudo snap install whatsapp-for-linux
sudo snap install spotify
