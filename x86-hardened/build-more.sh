#Add portage 
wget http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 /
mkdir -p /usr/portage/distfiles /usr/portage/metadata /usr/portage/packages 
bunzip2 -c  /portage-latest.tar.bz2 | tar -xf - -C /usr 
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
rm -f /Dockerfile /build-more.sh
