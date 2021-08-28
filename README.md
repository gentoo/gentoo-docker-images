# Gentoo Docker Images

[![build](https://github.com/gentoo/gentoo-docker-images/workflows/build/badge.svg)](https://github.com/gentoo/gentoo-docker-images/actions?workflow=build)

A collection of Dockerfiles for generating Gentoo docker images.

These images are intended to be created automatically by
a cron job and pushed to [docker hub](https://hub.docker.com/u/gentoo/).
This repository include basic stage3 images and an image usable as a `/usr/portage` volume

# DockerHub

https://hub.docker.com/u/gentoo/

## Inventory

The following targets are built and pushed to Docker Hub:
 * `portage`
 * `stage3`
   * `amd64`
     * `stage3-amd64-hardened-nomultilib-openrc`
     * `stage3-amd64-hardened-openrc`
     * `stage3-amd64-musl`
     * `stage3-amd64-musl-hardened`
     * `stage3-amd64-nomultilib-openrc`
     * `stage3-amd64-nomultilib-systemd`
     * `stage3-amd64-openrc`
     * `stage3-amd64-systemd`
   * `arm`
     * `stage3-armv5tel`
     * `stage3-armv5tel-systemd`
     * `stage3-armv6j`
     * `stage3-armv6j-systemd`
     * `stage3-armv6j_hardfp`
     * `stage3-armv6j_hardfp-systemd`
     * `stage3-armv7a`
     * `stage3-armv7a-systemd`
     * `stage3-armv7a_hardfp`
     * `stage3-armv7a_hardfp-systemd`
   * `arm64`
     * `stage3-arm64`
     * `stage3-arm64-systemd`
   * `ppc`
     * `stage3-ppc64le-musl-hardened-openrc`
     * `stage3-ppc64le-openrc`
     * `stage3-ppc64le-systemd`
   * `s390`
     * `stage3-s390x`
   * `x86`
     * `stage3-i686-hardened-openrc`
     * `stage3-i686-musl`
     * `stage3-i686-openrc`
     * `stage3-i686-systemd`

The following upstream stage3 targets are not built at all:
 * `amd64`
   * `stage3-amd64` [[deprecated](#deprecated)]
   * `stage3-amd64-hardened` [[deprecated](#deprecated)]
   * `stage3-amd64-hardened+nomultilib` [[deprecated](#deprecated)]
   * `stage3-amd64-hardened-selinux` [[deprecated](#deprecated), [selinux](#selinux)]
   * `stage3-amd64-hardened-selinux+nomultilib` [[deprecated](#deprecated), [selinux](#selinux)]
   * `stage3-amd64-hardened-selinux-openrc` [[selinux](#selinux)]
   * `stage3-amd64-musl-vanilla` [[deprecated](#deprecated)]
   * `stage3-amd64-nomultilib` [[deprecated](#deprecated)]
   * `stage3-amd64-nomultilib-selinux-openrc` [[selinux](#selinux)]
   * `stage3-amd64-uclibc-hardened` [[deprecated](#deprecated)]
   * `stage3-amd64-uclibc-vanilla` [[deprecated](#deprecated)]
   * `stage3-x32` [[deprecated](#deprecated), [unsupported](#unsupported)]
   * `stage3-x32-openrc` [[unsupported](#unsupported)]
 * `arm`
   * `stage3-armv4tl` [[unsupported](#unsupported)]
   * `stage3-armv4tl-systemd` [[unsupported](#unsupported)]
 * `ppc`
   * `stage3-power9le-openrc` [[unsupported](#unsupported)]
   * `stage3-power9le-systemd` [[unsupported](#unsupported)]
   * `stage3-ppc` [[deprecated](#deprecated), [unsupported](#unsupported)]
   * `stage3-ppc-openrc` [[unsupported](#unsupported)]
   * `stage3-ppc64` [[deprecated](#deprecated), [unsupported](#unsupported)]
   * `stage3-ppc64-musl-hardened` [[deprecated](#deprecated), [unsupported](#unsupported)]
   * `stage3-ppc64-musl-hardened-openrc` [[unsupported](#unsupported)]
   * `stage3-ppc64-openrc` [[unsupported](#unsupported)]
   * `stage3-ppc64-systemd` [[unsupported](#unsupported)]
   * `stage3-ppc64le` [[deprecated](#deprecated)]
   * `stage3-ppc64le-musl-hardened` [[deprecated](#deprecated)]
 * `s390`
   * `stage3-s390` [[unsupported](#unsupported)]
 * `x86`
   * `stage3-i486` [[deprecated](#deprecated), [unsupported](#unsupported)]
   * `stage3-i486-openrc` [[unsupported](#unsupported)]
   * `stage3-i686` [[deprecated](#deprecated)]
   * `stage3-i686-hardened` [[deprecated](#deprecated)]
   * `stage3-i686-musl-vanilla` [[deprecated](#deprecated)]
   * `stage3-i686-uclibc-hardened` [[deprecated](#deprecated)]
   * `stage3-i686-uclibc-vanilla` [[deprecated](#deprecated)]

<a name="deprecated">[deprecated]</a>: Deprecated stage3 target

<a name="selinux">[selinux]</a>: [SELinux doesn't seem to make sense inside containers](https://serverfault.com/q/757606/)

<a name="unsupported">[unsupported]</a>: [Unsupported Docker architecture](https://github.com/docker-library/official-images#architectures-other-than-amd64)

# Building the containers

The containers are created using a multi-stage build, which requires Docker >= 19.03.0.
The container being built is defined by the TARGET environment variable:

`` TARGET=stage3-amd64 ./build.sh ``

# Using the portage container as a data volume

```
docker create -v /usr/portage --name myportagesnapshot gentoo/portage:latest /bin/true
docker run --interactive --tty --volumes-from myportagesnapshot gentoo/stage3-amd64:latest /bin/bash
```

# Using the portage container in a multi-stage build

docker-17.05.0 or later supports multi-stage builds, allowing the portage volume to be used when creating images based on a stage3 image.

Example _Dockerfile_

```
# name the portage image
FROM gentoo/portage:latest as portage

# based on stage3 image
FROM gentoo/stage3:latest

# copy the entire portage volume in
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

# continue with image build ...
RUN emerge -qv www-servers/apache # or whichever packages you need
```


# Contributing

We'd love to hear any ideas.  Feel free to contact us via any of the following
methods:

* IRC: irc://irc.libera.chat:6697/#gentoo-containers
* EMAIL: gentoo-containers@lists.gentoo.org
* GITHUB: https://github.com/gentoo/gentoo-docker-images

## Policy

* Use topic branches (i.e. foo) and fix branches (i.e. fix/foo) when submitting
  pull requests
* Make meaningful commits ideally with the following form:
  * Subject line–what this commit does
  * Blank line
  * Body–why this commit is necessary or desired
* Pull requests should not include merge commits
* Use amend and rebase to fix commits after a pull request has been submitted
