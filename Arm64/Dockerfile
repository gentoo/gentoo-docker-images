FROM scratch
MAINTAINER Necrose99
ENV ARCH=arm64
VOLUME /var/lib/layman:rw, /usr/portage:rw", /usr/portage/distfiles:rw, 
ADD https://raw.githubusercontent.com/necrose99/Docker-Gentoo-ARM64/master/build/qemu-arm64.conf /etc/binfmt.d
## add binformat to host and to chroot area 
ADD http://distfiles.gentoo.org/experimental/arm64/stage3-arm64-20180711.tar.bz2 /


# Set locales to en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
# Set environment variables.
ENV HOME /root
# fire up the chroot
#### if your runing this as a chroot proot ,  etc from amd64 : 
### tpye :  ./proot -R / -q ./umeq-arm64 /bin/bash
ENTRYPOINT ["./proot -R / -q ./umeq-arm64 /bin/bash"]





