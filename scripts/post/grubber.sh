#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
set -oue pipefail

cd /tmp
git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
cd Graphite-gtk-theme/other/grub2/
sudo ./install.sh -b
cd /tmp
rm -rf Graphite-gtk-theme
