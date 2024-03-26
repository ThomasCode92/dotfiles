#!/bin/sh

# Download the Google Chrome .deb package
cd ~/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Install the Google Chrome .deb package
sudo dpkg -i google-chrome-stable_current_amd64.deb
