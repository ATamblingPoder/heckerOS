# This is the Containerfile for your custom image. 

# It takes in the recipe, version, and base image as arguments,
# all of which are provided by build.yml when doing builds
# in the cloud. The ARGs have default values, but changing those
# does nothing if the image is built in the cloud.

ARG FEDORA_MAJOR_VERSION=38
# Warning: changing this might not do anything for you. Read comment above.
ARG BASE_IMAGE_URL=quay.io/fedora-ostree-desktops/silverblue

FROM ${BASE_IMAGE_URL}:${FEDORA_MAJOR_VERSION}

# The default recipe set to the recipe's default filename
# so that `podman build` should just work for many people.
ARG RECIPE=./recipe.yml

# The default image registry to write to policy.json and cosign.yaml
ARG IMAGE_REGISTRY=quay.io/fedora-ostree-desktops/silverblue

# Copy static configurations and component files.
# Warning: If you want to place anything in "/etc" of the final image, you MUST
# place them in "./usr/etc" in your repo, so that they're written to "/usr/etc"
# on the final system. That is the proper directory for "system" configuration
# templates on immutable Fedora distros, whereas the normal "/etc" is ONLY meant
# for manual overrides and editing by the machine's admin AFTER installation!
# See issue #28 (https://github.com/ublue-os/startingpoint/issues/28).
COPY usr /usr

# Copy public key
COPY cosign.pub /usr/share/ublue-os/cosign.pub

# Copy the recipe that we're building.
COPY ${RECIPE} /usr/share/ublue-os/recipe.yml

# Copy nix install script and Universal Blue wallpapers RPM from Bling image
# COPY --from=ghcr.io/ublue-os/bling:latest /rpms/ublue-os-wallpapers-0.1-1.fc38.noarch.rpm /tmp/ublue-os-wallpapers-0.1-1.fc38.noarch.rpm

# Integrate bling justfiles onto image
# COPY --from=ghcr.io/ublue-os/bling:latest /files/usr/share/ublue-os/just /usr/share/ublue-os/just

# Add nix installer if you want to use it
# COPY --from=ghcr.io/ublue-os/bling:latest /files/usr/bin/ublue-nix* /usr/bin

# "yq" used in build.sh and the "setup-flatpaks" just-action to read recipe.yml.
# Copied from the official container image since it's not available as an RPM.
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq


# COPY --from=ghcr.io/ublue-os/config:latest /files/usr /usr
# COPY --from=ghcr.io/ublue-os/config:latest /files/etc /etc
COPY --from=ghcr.io/ublue-os/config:latest /rpms/ublue-os-udev-rules.noarch.rpm /
COPY --from=ghcr.io/ublue-os/config:latest /rpms/ublue-os-update-services.noarch.rpm /
# RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/gnome-vrr/repo/fedora-$(rpm -E %fedora)/kylegospo-gnome-vrr-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-gnome-vrr.repo 
RUN rpm -ivh /ublue-os-udev-rules.noarch.rpm
RUN rpm -ivh /ublue-os-update-services.noarch.rpm

# Copy the build script and all custom scripts.
COPY scripts /tmp/scripts

RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
RUN rpm-ostree override remove libavcodec-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free mesa-va-drivers

# Run the build script, then clean up temp files and finalize container build.
RUN chmod +x /tmp/scripts/build.sh && \
        /tmp/scripts/build.sh && \
        rm -rf /tmp/* /var/*

RUN rm -rf /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo \
    /etc/yum.repos.d/fedora-updates-testing* /etc/yum.repos.d/google-chrome \
    /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo /etc/yum.repos.d/rpmfusion-nonfree-updates-testing.repo\ 
    /etc/yum.repos.d/rpmfusion-free-updates-testing.repo

# RUN sudo rm -rf /usr/share/glib-2.0/schemas/org.gnome.mutter.gschema.xml
# RUN echo "\n Removed /usr/share/glib-2.0/schemas/org.gnome.mutter.gschema.xml \n"
# RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:kylegospo:gnome-vrr mutter gnome-control-center gnome-control-center-filesystem xorg-x11-server-Xwayland --dry-run
RUN systemctl enable com.system76.Scheduler
RUN ostree container commit