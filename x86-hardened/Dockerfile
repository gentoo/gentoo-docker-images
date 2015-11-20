FROM necrose99/gentoo-docker-x86
# Hardend dont wana build the normal Way so OVERLAY it on a good Gentoo,
MAINTAINER   Necrose99 #Gentoo Docker Team

RUN eselect profile set i686-pc-linux-gnu-4.5.3-hardenednopie
source /etc/profile
emerge --oneshot gcc
emerge --oneshot binutils virtual/libc
emerge --depclean prelink
emerge --emptytree --verbose @world
#Add portage
RUN cd /

RUN wget -q -c  http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 /

RUN tar xvjpf stage3-*.tar.bz2 

RUN bzcat /portage-latest.tar.bz2 | tar -xf - -C /usr
RUN mkdir -p /usr/portage/distfiles /usr/portage/metadata /usr/portage/packages

RUN rm /portage-latest.tar.bz2
RUN rm /stage3-i686-hardened-20151117.tar.bz2
#Add Layman
Run emerge --sync
RUN emerge -v =dev-lang/python-2* =dev-lang/python-3* 
Run Emerge -v git layman potage
Run Emerge -v sys-fs/squashfs-tools app-arch/p7zip
