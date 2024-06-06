#!/bin/sh

# Dowmload & unpack the font
cd ~/Downloads/
curl -L -O https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip Hack.zip -d Hack

# Install the fonts
mkdir ~/.fonts
mv -v Hack/* ~/.fonts
fc-cache -f -v
