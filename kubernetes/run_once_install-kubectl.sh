#!/bin/bash

# Download kubectl and its checksum
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

# Extract checksum from the file
checksum=$(awk '{ print $1 }' kubectl.sha256)

# Calculate checksum of the downloaded binary
downloaded_checksum=$(sha256sum kubectl | awk '{ print $1 }')

# Verify the checksum
if [[ "$checksum" == "$downloaded_checksum" ]]; then
    echo "Checksum is OK. Installing kubectl..."
    # Install kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    echo "kubectl installed successfully."
else
    echo "Checksum verification failed. Aborting installation."
    # Clean up downloaded files if checksum verification failed
    rm kubectl kubectl.sha256
fi
