# Gentoo Docker Images

[![Build Status](https://travis-ci.org/gentoo/gentoo-docker-images.svg?branch=master)](https://travis-ci.org/gentoo/gentoo-docker-images)

A collection of Dockerfiles for generating Gentoo docker images.

These images are intended to be created automatically by
a travis cron job and pushed to [docker hub](https://hub.docker.com/u/gentoo/).
This repository include basic stage3 images and an image usable as a `/usr/portage` volume

# DockerHub

https://hub.docker.com/u/gentoo/

## Inventory

* portage
* stage3
  * stage3-amd64
    * stage3-amd64-hardened
    * stage3-amd64-nomultilib
    * stage3-amd64-hardened-nomultilib
  * stage3-x86
    * stage3-x86-hardened

# Building the containers

The containers are created using a multi-stage build, which requires docker-17.05.0 or later.
The container being built is defined by the TARGET environment variable:

`` TARGET=stage-amd64 ./build.sh ``

# Using the portage container as a data volume

```
docker create -v /usr/portage --name myportagesnapshot gentoo/portage:latest /bin/true
docker run --volumes-from myportagesnapshot gentoo/stage-amd64:latest /bin/bash
```

# Contributing

We'd love to hear any ideas.  Feel free to contact us via any of the following
methods:

* IRC: irc://freenode.net/#gentoo-containers
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
