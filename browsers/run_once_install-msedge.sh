#!/bin/sh

# Download the Microsoft Edge .rpm package
cd ~/Downloads
wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_124.0.2478.51-1_amd64.deb

# Install the Microsoft Edge .rpm package
sudo dpkg -i microsoft-edge-stable_124.0.2478.51-1_amd64.deb
