###Docker Base Gentoo ARM64 package
Here is my Gentoo ARM64 stage3 docker package.
###<b>FROM scratch MAINTAINER Necrose99 necrose99@protonmail.net </b>
###A & B Gentoo Arm64 curent Tarball is provided,  along with portage 
pre editied  /etc/resolv.conf 

###C:  https://github.com/mickael-guene/umeq/releases/download/1.7.4/umeq-arm64 
####Umeq is an equivalent of Qemu user mode. 
It allows you to run foreign architecture binaries on your host system. 
For example you can <b> run arm64 binaries on x86_64 linux desktop.</b> so thus your regular AMD/Intel i7 can build for arm64 rather easily.

###D: ADD https://raw.githubusercontent.com/mickael-guene/proot-static-build/master-umeq/static/proot-x86_64
### E: proot startup script to initilize the chroot, a few updater/misc scripts a Self terminating clean up dockerfile/tarballs script.

 credits @mickael-guene for the proot-static & umeq-arm64 wich make this project feasible with far less hell and frustration of other means, ie QEMU static , arm64 binformat etc. 
 ## useage use the built in scripts for cloud or ie <b>bash# ./proot-start <b>
###Emerge or equo i sys-apps/proot ( <i> if sabayon entropy</i> ) and qemu  or else host package manager deb/rpm etc. Debian you'll likely need multi-starp err see:
== https://github.com/mickael-guene/umeq/ == 

Also Proot and Quemu on the Gentoo Host holding docker. 
sys-apps/proot sys-apps/proot

https://archives.gentoo.org/gentoo-embedded/message/9b96f5fd00a9c5e65e062f3d6e99fc50

https://armin762.wordpress.com/2013/12/07/aarch64arm64-in-gentoo/

much in means of refinments , improvemnts to the emulators being shiped with the image and or the like. 
to that End https://github.com/necrose99/Docker-Gentoo-ARM64 i'm tinkering away, however to the Gentoo Docker team I give this image
as to hopefully have better arm64 stage 3s and packages out 

!!BETA!! state , 
https://quay.io/repository/necrose99/gentoo_arm64
https://quay.io/repository/necrose99/gentoo_arm64_chroot  pure gentoo-docker-image + arm64 /chroot volume and a few emulators to
proot/chroot into the arm64 folder to attempt to build or test with. 
