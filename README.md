# Gentoo Docker Images

A repository of Dockerfiles and utilities for generating Gentoo docker images.

Currently we are working on adding amd64 images and will expand into other
arches over time.

## Inventory

* portage

# About the shipped BusyBox binary

To unpack itself from a stage3 tarball, the Gentoo docker images need a
statically linked busybox. To make the automatic builds possible, this binary
has been added to this repository, under the `busybox` directory.

The `busybox` binary should be statically linked against uClibc (when linked
with GNU libc, network name resolution fails because `libnss` apparently
doesn't like being statically linked.)

Instructions for building a the busybox binary (note, building the toolchain
might take a while):

```bash
sudo crossdev -S -v -t x86_64-pc-linux-uclibceabi -v
sudo ARCH="amd64" \
     ACCEPT_KEYWORDS="~amd64" \
     FEATURES="buildpkg" \
     USE="static systemd -make-symlinks" \
  x86_64-pc-linux-uclibceabi-emerge -at busybox
```

After the build finishes, the `busybox` binary will be located at
`/usr/x86_64-pc-linux-uclibceabi/bin/busybox`.

# Contributing

Join us at irc://freenode.net/#gentoo-containers.  We'd love to hear any ideas.

## Policy

* use topic branches (i.e. foo) and fix branches (i.e. fix/foo) when submitting
  pull requests
* make meaningful commits ideally with the following form:
  * subject line–what this commit does
  * blank line
  * body–why this commit is necessary or desired
* pull requests should not include merge commits
* use amend and rebase to fix commits after a pull request has been submitted
