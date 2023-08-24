# heckerOS

[![build-ublue](https://github.com/ATamblingPoder/heckerOS/actions/workflows/build.yml/badge.svg)](https://github.com/ATamblingPoder/heckerOS/actions/workflows/build.yml)

This is a custom build of [Fedora Silverblue](https://fedoraproject.org/silverblue) with a bunch of custom gaming related and miscellaneous stuff with [linux-cachyos-bore-eevdf](https://github.com/cachyos/linux-cachyos) kernel, [system76-scheduler](https://github.com/pop-os/system76-scheduler), and mutter replaced with [mutter-vrr](https://copr.fedorainfracloud.org/coprs/kylegospo/gnome-vrr/) for Variable Refresh Rate Support.

Made using [uBlue](https://universal-blue.org/).

## Installation

To rebase an existing Silverblue/Kinoite installation to the latest build:

- First rebase to the image unsigned, to get the proper signing keys and policies installed:
  ```
  sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/atamblingpoder/heckeros:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/atamblingPoder/heckeros:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```


This repository builds date tags as well, so if you want to rebase to a particular day's build:

```
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/atamblingpoder/heckeros:20230403
```

This repository by default also supports signing 

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO
The ISO directly installs this image for you! However, this image is a bit on the larger side so make sure you have a fast internet connection.

