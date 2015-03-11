stage3_suffix="" # e.g. -hardened
dist="http://distfiles.gentoo.org/releases/amd64/autobuilds"
stage3="$(wget -O- ${dist}/latest-stage3-amd64${suffix}.txt | tail -n 1 | cut -f 1 -d ' ')"

mkdir newWorldOrder; cd newWorldOrder
echo "Downloading and extracting ${stage3}..."
#wget -c "${dist}/${stage3}"
cp /container/amd64/stage3-amd64-20150305.tar.bz2 .
bunzip2 -c $(basename ${stage3}) | tar --exclude "./etc/hosts" --exclude "./sys/*" -xvf -
#wget http://www.busybox.net/downloads/binaries/latest/busybox-x86_64
cp /container/busybox-x86_64 /busybox
chmod +x /busybox
/busybox rm -rf /lib64 /lib /lib32 /usr /var /bin /opt /mnt /media /root
/busybox mv -f lib64 /
/busybox mv -f lib32 /
/busybox mv -f lib /
/busybox mv -f * /
#rm -rf /lib /lib64 /usr/bin /bin
#cp -rafld lib64 lib lib32 bin /

#busybox chroot ./
## Setup the rc_sys
#sed -e 's/#rc_sys=""/rc_sys="lxc"/g' -i /etc/rc.conf

## Setup the net.lo runlevel
#ln -s /etc/init.d/net.lo /run/openrc/started/net.lo

## Setup the net.eth0 runlevel
#ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
#ln -s /etc/init.d/net.eth0 /run/openrc/started/net.eth0

## By default, UTC system
#echo 'UTC' > /etc/timezone

## Self destruct
#rm /Dockerfile
#rm /build.sh

#echo "Bootstrapped ${stage3} into /:"
#ls --color -lah