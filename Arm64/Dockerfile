FROM scratch
MAINTAINER Necrose99
ENV ARCH=arm64
VOLUME /var/lib/layman:rw, /usr/portage:rw", /usr/portage/distfiles:rw, 
ADD https://raw.githubusercontent.com/necrose99/Docker-Gentoo-ARM64/master/build/qemu-arm64.conf /etc/binfmt.d
## add binformat to host and to chroot area 
ADD http://distfiles.gentoo.org/experimental/arm64/stage3-arm64-20160324.tar.bz2 /
ADD https://github.com/mickael-guene/umeq/releases/download/1.7.4/umeq-arm64 /
ADD https://raw.githubusercontent.com/mickael-guene/proot-static-build/master-umeq/static/proot-x86_64 /proot
ADD https://raw.githubusercontent.com/necrose99/gentoo-docker-images/master/Arm64/build/register  /proc/sys/fs/binfmt_misc

# Set locales to en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
# Set environment variables.
ENV HOME /root
# fire up the chroot
#### if your runing this as a chroot proot ,  etc from amd64 : 
### tpye :  ./proot -R / -q ./umeq-arm64 /bin/bash
ENTRYPOINT ["./proot -R / -q ./umeq-arm64 /bin/bash"]





