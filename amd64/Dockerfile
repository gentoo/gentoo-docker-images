FROM scratch
MAINTAINER Gentoo Container Team <containers@gentoo.org>

# Run the build script with the bootstrapped BusyBox:
ADD . /
RUN ["/bin/busybox", "sh", "build.sh"]

# Used when this image is the base of another

# Setup the portage directory and permissions
ONBUILD RUN mkdir -p /usr/portage/{distfiles,metadata,packages}
ONBUILD RUN chown -R portage:portage /usr/portage
ONBUILD RUN echo "masters = gentoo" > /usr/portage/metadata/layout.conf

# Sync portage
ONBUILD RUN emerge-webrsync -q

# Display some news items
ONBUILD RUN eselect news read new

# Finalization
ONBUILD RUN env-update
