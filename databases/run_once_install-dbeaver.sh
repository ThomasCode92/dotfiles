#!/bin/sh

# Download the DBeaver .deb package
cd ~/Downloads
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb

# Install the DBeaver .deb package
sudo dpkg -i dbeaver-ce_latest_amd64.deb