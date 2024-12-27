#!/bin/sh

wget https://downloads.raspberrypi.org/imager/imager_latest_amd64.deb
sudo dpkg -i imager_latest_amd64.deb

sudo apt-get install -f -y
