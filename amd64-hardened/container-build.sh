suffix="-hardened" # e.g. -hardened
arch="amd64"
busybox_version="x86_64"
dist="http://distfiles.gentoo.org/releases/${arch}/autobuilds/"
stage3="$(wget -q -O- ${dist}/latest-stage3-${arch}${suffix}.txt | tail -n 1 | cut -f 1 -d ' ')"

mkdir newWorldOrder; cd newWorldOrder
echo "Downloading and extracting ${stage3}..."
wget -q -c "${dist}/${stage3}"
#cp "/container/stage3-${arch}-20150305.tar.bz2" .
bunzip2 -c $(basename ${stage3}) | tar --exclude "./etc/hosts" --exclude "./sys/*" -xf -
rm -f $(basename ${stage3})
wget -q -O /busybox "http://www.busybox.net/downloads/binaries/latest/busybox-${busybox_version}"
#cp "/container/busybox-${busybox_version}" /busybox
chmod +x /busybox
/busybox rm -rf /lib* /usr /var /bin /sbin /opt /mnt /media /root /home /run /tmp
/busybox mv -f lib* /
/busybox mv -f bin boot home media mnt opt root run sbin tmp usr var /
/busybox cp -raf etc/* /etc/
#/busybox wget -q -c http://distfiles.gentoo.org/gentoo/releases/snapshots/current/portage-latest.tar.xz
##/busybox cp /container/portage-latest.tar.xz .
#/busybox xzcat portage-latest.tar.xz | tar -C /usr/ -xf -
cd /
#commit suicide
/busybox rm -rf newWorldOrder /busybox /container-build.sh /portage-latest.tar.xz
#busybox chroot ./




# Setup the rc_sys
sed -e 's/#rc_sys=""/rc_sys="lxc"/g' -i /etc/rc.conf

# Setup the net.lo runlevel
ln -s /etc/init.d/net.lo /run/openrc/started/net.lo

# Setup the net.eth0 runlevel
ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
ln -s /etc/init.d/net.eth0 /run/openrc/started/net.eth0

# By default, UTC system
echo 'UTC' > /etc/timezone

# Self destruct
rm -f /Dockerfile /build.sh container-build.sh

echo "Bootstrapped ${stage3} into /:"
ls --color -lah
