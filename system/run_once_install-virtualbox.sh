#!/bin/sh

wget https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Ubuntu~noble_amd64.deb

sudo dpkg -i virtualbox-7.1_7.1.4-165100~Ubuntu~noble_amd64.deb || [ $? -eq 1 ] && sudo apt-get install -f
