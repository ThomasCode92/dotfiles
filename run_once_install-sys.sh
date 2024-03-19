#!/bin/sh

# htop
sudo apt update && sudo apt upgrade
sudo apt install htop

# Postman CLI
curl -o- "https://dl-cli.pstmn.io/install/linux64.sh" | sh
sudo snap install postman

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# age
sudo apt install age

