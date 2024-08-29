#!/bin/sh

mkdir zen

# Define variables
DOWNLOAD_URL="https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-specific.tar.bz2"
TARBALL="zen.linux-specific.tar.bz2"
INSTALL_DIR="$(pwd)/zen"  # Set the current directory as the install directory
EXECUTABLE="zen"

# Download the tarball
echo "Downloading Zen Browser..."
wget -O $TARBALL $DOWNLOAD_URL

# Extract the tarball to the current directory
echo "Extracting Zen Browser..."
tar -xjf $TARBALL --strip-components=1 -C $INSTALL_DIR

# Create a symbolic link in /usr/local/bin to make it accessible globally
echo "Creating symbolic link..."
sudo ln -sf $INSTALL_DIR/$EXECUTABLE /usr/local/bin/$EXECUTABLE

# Clean up
echo "Cleaning up..."
rm $TARBALL

# Confirm installation
echo "Zen Browser installed successfully in $INSTALL_DIR! You can run it using the command: zen"
