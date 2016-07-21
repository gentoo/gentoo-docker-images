suffix=$3 # e.g. -hardened
arch=$1
busybox_version=$2
dist="http://distfiles.gentoo.org/releases/${arch}/autobuilds/"
stage3="$(wget -q -O- ${dist}/latest-stage4-${arch}${suffix}.txt | tail -n 1 | cut -f 1 -d ' ')"
# http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage4-amd64-hardened+cloud.txt

mkdir newWorldOrder; cd newWorldOrder
echo "Downloading and extracting ${stage4}..."
wget -q -c "${dist}/${stage4}"
bunzip2 -c $(basename ${stage4}) | tar --exclude "./etc/hosts" --exclude "./sys/*" -xf -
rm -f $(basename ${stage4})
wget -q -O /busybox "http://www.busybox.net/downloads/binaries/latest/busybox-${busybox_version}"
chmod +x /busybox
/busybox rm -rf /lib* /usr /var /bin /sbin /opt /mnt /media /root /home /run /tmp
/busybox cp -fRap lib* /
/busybox cp -fRap bin boot home media mnt opt root run sbin tmp usr var /
/busybox cp -fRap etc/* /etc/
cd /
#commit suicide
/busybox rm -rf newWorldOrder /busybox /build.sh /linuxrc

latest_stage3=$(curl "${base_url}/latest-stage3-amd64-hardened.txt" 2>/dev/null | grep -v '#' | awk '{print $1}')
stage3=$(basename "${latest_stage3}")

echo "Bootstrapped ${stage4} into /:"
ls --color -lah
#Add portage 
wget http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 / 
bzcat /portage-latest.tar.bz2 | tar -xf - -C /usr 
mkdir -p /usr/portage/distfiles /usr/portage/metadata /usr/portage/packages 
rm /portage-latest.tar.bz2 

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

# Self destruct
rm -f /Dockerfile /build.sh
