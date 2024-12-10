#!/bin/sh

# Download and extract the IntelliJ tarball
wget https://download.jetbrains.com/idea/ideaIC-2024.3.1.tar.gz
sudo tar -xzf ideaIC-*.tar.gz -C /opt

# execute the idea.sh script
/opt/idea-IC-*/bin/idea.sh
