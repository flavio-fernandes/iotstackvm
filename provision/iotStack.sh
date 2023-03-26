#!/usr/bin/env bash
#

[ $EUID -eq 0 ] && { echo 'must no be root' >&2; exit 1; }

set -o errexit
set -o xtrace

# git clone https://github.com/Paraphraser/PiBuilder.git ~/PiBuilder

# https://learnembeddedsystems.co.uk/easy-raspberry-pi-iot-server

sudo touch /boot/cmdline.txt
cd
curl -fsSL https://raw.githubusercontent.com/SensorsIot/IOTstack/master/install.sh | bash


