
[![Docker Stars](https://img.shields.io/docker/stars/necrose99/gentoo-x86-hardened.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/necrose99/gentoo-x86-hardened.svg)][hub]
[![IRC Channel](https://img.shields.io/badge/irc-%23necrose99-blue.svg)][irc]
[![Image Size](https://img.shields.io/imagelayers/image-size/necrose99/gentoo-x86-hardened/latest.svg)](https://imagelayers.io/?images=necrose99/gentoo-x86-hardened:latest)
[![Image Layers](https://img.shields.io/imagelayers/layers/necrose99/gentoo-x86-hardened/latest.svg)](https://imagelayers.io/?images=necrose99/gentoo-x86-hardened:latest)


# Docker Base Gentoo package
Here is my Gentoo Hardend stage3 docker package.
<code>
FROM scratch MAINTAINER Necrose99 necrose99@protonmail.net 

ADD http://distfiles.gentoo.org/releases/x86/autobuilds/current-stage3-i686/hardened/stage3-i686-hardened-20151124.tar.bz2 /

CMD ["/bin/bash"]
</code>
**Linked Repositories:
gentoo/portage**
