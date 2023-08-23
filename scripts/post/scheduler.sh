#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
set -oue pipefail

sudo wget https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-$(rpm -E %fedora)/kylegospo-system76-scheduler-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo
sudo rpm-ostree install system76-scheduler
