# Gentoo Docker Images

A collection of Dockerfiles for generating Gentoo docker images.

These images are intended to be created automatically by
[docker hub](https://hub.docker.com/u/gentoo/) and include basic
stage3 images and an image usable as a `/usr/portage` volume.

# DockerHub

https://registry.hub.docker.com/u/gentoo/stage3-amd64/

## Inventory

* portage
* stage3
  * stage3-amd64
    * stage3-adm64-hardened
    * stage3-amd64-nomultilib

# Contributing

We'd love to hear any ideas.  Feel free to contact us via any of the following
methods:

* IRC: irc://freenode.net/#gentoo-containers
* EMAIL: gentoo-containers@lists.gentoo.org
* GITHUB: https://github.com/gentoo/gentoo-docker-images

## Policy

* use topic branches (i.e. foo) and fix branches (i.e. fix/foo) when submitting
  pull requests
* make meaningful commits ideally with the following form:
  * subject line–what this commit does
  * blank line
  * body–why this commit is necessary or desired
* pull requests should not include merge commits
* use amend and rebase to fix commits after a pull request has been submitted
