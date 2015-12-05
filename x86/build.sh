suffix=hardened
arch=$1
busybox_version=$2
dist="http://distfiles.gentoo.org/releases/${arch}/autobuilds/"
stage3="$(wget -q -O- ${dist}/latest-stage3-${busybox_version}${suffix}.txt | tail -n 1 | cut -f 1 -d ' ')"

mkdir newWorldOrder; cd newWorldOrder
echo "Downloading and extracting ${stage3}..."
wget -q -c "${dist}/${stage3}"
bunzip2 -c $(basename ${stage3}) | tar --exclude "./etc/hosts" --exclude "./sys/*" -xf -
rm -f $(basename ${stage3})
#Add portage
wget -q -c  http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2
bzcat /newWorldOrder/portage-latest.tar.bz2 | tar -xf - -C /newWorldOrder/usr
mkdir -p usr/newWorldOrder/portage/distfiles usr/portage/metadata /usr/portage/packages
#Busy Box
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

echo "Bootstrapped ${stage3} into /:"
ls --color -lah
#Add Layman
mkdir /etc/portage/package.accept_keywords 
mkdir -p /etc/portage/package.use 
# avoid a Python 2 dependency 
echo 'dev-vcs/git >> /etc/portage/package.use/layman 
echo 'app-portage/layman ~x86' >> /etc/portage/package.accept_keywords/layman 
echo 'dev-python/ssl-fetch ~x86' >> /etc/portage/package.accept_keywords/layman 

emerge --sync 
emerge -v git layman potage =dev-lang/python-2.7.10-r3  dev-lang/python sys-fs/squashfs-tools app-arch/p7zip
eselect news read new 
echo 'source /var/lib/layman/make.conf' >> /etc/portage/make.conf 
sed -i 's/^check_official.*/check_official : no/' /etc/layman/layman.cfg 
layman --fetch 
layman -L && Layman -a pentoo && layman -a sabayon && layman -a sabayon-distro
emerge >=app-admin/equo-300 >=entropy/entropy-300 >=app-admin/matter-300 >=sys-apps/entropy-server-300.ebuild
