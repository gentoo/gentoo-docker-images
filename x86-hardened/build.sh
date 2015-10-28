#suffix=$3 # e.g. -hardened
#arch=$1
busybox_version=$2

# http://distfiles.gentoo.org/releases/x86/autobuilds/latest-stage3-i686-hardened.txt
#dist="http://distfiles.gentoo.org/releases/${arch}/autobuilds/"
#stage3="$(wget -q -O- ${dist}/latest-stage3-${busybox_version}${suffix}.txt | tail -n 1 | cut -f 1 -d ' ')"
# http://distfiles.gentoo.org/releases/x86/autobuilds/latest-stage3-i686-hardened.txt
# https://github.com/shift/gentoo-stage3-docker/blob/master/build.sh git this DONE... and many thanks... 
LATEST_VERSION=

if [ -z "$LATEST_VERSION" ]; then
  LATEST_VERSION=autobuild-20151027$LATEST_VERSION`curl 'http://distfiles.gentoo.org/releases/x86/autobuilds/latest-stage3-i686-hardened.txt' | tail -n 1`
  TAG=autobuild-`echo $LATEST_VERSION | sed -n 's|\(.*\)\/.*|\1|p'`
fi
echo "Downloading and extracting ${stage3}..."
mkdir newWorldOrder; cd newWorldOrder
wget -c "http://distfiles.gentoo.org/releases/x86/autobuilds/${LATEST_VERSION}"
bunzip2 -c ${LATEST_VERSION} | tar --exclude "./etc/hosts" --exclude "./sys/*" -xf -
rm -f ${LATEST_VERSION}
wget -q -O /busybox "http://www.busybox.net/downloads/binaries/latest/busybox-${busybox_version}"
chmod +x /busybox
/busybox rm -rf /lib* /usr /var /bin /sbin /opt /mnt /media /root /home /run /tmp
/busybox cp -fRap lib* /
/busybox cp -fRap bin boot home media mnt opt root run sbin tmp usr var /
/busybox cp -fRap etc/* /etc/
cd /
#commit suicide
/busybox rm -rf newWorldOrder /busybox /build.sh /linuxrc

# Self destruct
rm -f /Dockerfile /build.sh

echo "Bootstrapped ${LATEST_VERSION}" into /:"
ls --color -lah
