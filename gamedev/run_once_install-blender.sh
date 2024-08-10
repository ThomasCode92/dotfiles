#!/bin/bash

cd ~/Downloads

sudo mkdir /opt/blender

curl -L https://download.blender.org/release/Blender4.2/blender-4.2.0-linux-x64.tar.xz -O

tar -xf blender-4.2.0-linux-x64.tar.xz -C ~/Downloads
sudo mv blender-4.2.0-linux-x64 /opt/blender
sudo ln -sf /opt/blender/blender-4.2.0-linux-x64/blender /usr/local/bin/blender

rm blender-4.2.0-linux-x64.tar.xz
