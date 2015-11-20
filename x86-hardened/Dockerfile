FROM necrose99/gentoo-docker-x86
# Hardend dont wana build the normal Way so OVERLAY it on a good Gentoo,
MAINTAINER   Necrose99 #Gentoo Docker Team

RUN eselect profile set i686-pc-linux-gnu-4.5.3-hardenednopie
RUN source /etc/profile
RUN emerge --oneshot gcc
RUN emerge --oneshot binutils virtual/libc
RUN emerge --depclean prelink
RUN emerge --emptytree --verbose @world
#Add portage
RUN cd /
RUN wget -q -c  http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 /
RUN bzcat /portage-latest.tar.bz2 | tar -xf - -C /usr
RUN mkdir -p /usr/portage/distfiles /usr/portage/metadata /usr/portage/packages

RUN rm /portage-latest.tar.bz2
RUN rm /stage3-i686-hardened-20151117.tar.bz2
#Add Layman
Run emerge --sync
RUN emerge -v =dev-lang/python-2* =dev-lang/python-3* 
RUN Emerge -v git layman potage
RUN  Emerge -v sys-fs/squashfs-tools app-arch/p7zip
