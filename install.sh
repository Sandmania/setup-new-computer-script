#!/bin/bash
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/Sandmania/setup-new-computer-script/master/install.sh)"
set -euox
git clone https://github.com/Sandmania/setup-new-computer-script.git
cd setup-new-computer-script
git checkout sandman-specific
./setup-new-computer.sh
