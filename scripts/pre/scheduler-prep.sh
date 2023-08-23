#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
set -oue pipefail

# rpm-ostree install rust cargo clang clang-devel pipewire-devel rust-pipewire-devel pkgconf-pkg-config
echo $(just --version)
