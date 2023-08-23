#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
set -oue pipefail

cd /tmp
git clone https://github.com/pop-os/system76-scheduler.git
cd system76-scheduler
just execsnoop=$(which execsnoop-bpfcc) build-release
sudo just sysconfdir=/usr/share install
