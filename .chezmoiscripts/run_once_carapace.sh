#!/bin/bash

# For more information, see
# https://carapace-sh.github.io/carapace-bin/carapace-bin.html

echo "deb [trusted=yes] https://apt.fury.io/rsteube/ /" | sudo tee /etc/apt/sources.list.d/fury.list >/dev/null

sudo apt-get update && sudo apt-get install carapace-bin
