#!/bin/sh

# Postman CLI
curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | sh
sudo snap install postman

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# apt packages
sudo apt update && sudo apt upgrade
sudo apt install htop
sudo apt install age
sudo apt install build-essential
sudo apt install python3.10-venv

# snap packages
sudo snap install bluemail
sudo snap install teams-for-linux
sudo snap install whatsapp-for-linux
sudo snap install spotify
