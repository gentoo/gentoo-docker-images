#!/bin/bash

rm ../gentoo1.tar.xz &> /dev/null
rm ../gentoo2.tar.xz &> /dev/null
rm ../gentoo3.tar.xz &> /dev/null
rm ../gentoo4.tar.xz &> /dev/null
rm ../gentoo5.tar.xz &> /dev/null

rm system/root/.bash_history &> /dev/null
rm system/root/update.sh &> /dev/null
rm -r system/tmp/* &> /dev/null
rm -r system/usr/portage &> /dev/null
rm -r system/usr/share/doc &> /dev/null
rm -r system/usr/share/man/?? &> /dev/null
rm -r system/usr/share/man/??_* &> /dev/null
rm -r system/var/tmp/* &> /dev/null
rm -r system/var/log/* &> /dev/null

cd system/
echo -n 'Start - '
date '+%H:%M:%S'
echo
XZ_OPT=-9 bsdtar --exclude="usr/lib64" --exclude="usr/share" -Jcf ../../gentoo1.tar.xz .
echo -n 'OK - '
date '+%H:%M:%S'
echo -n '   - '
du -sh ../../gentoo1.tar.xz
echo
XZ_OPT=-9 bsdtar -Jcf ../../gentoo2.tar.xz usr/lib64/python*
echo -n 'OK - '
date '+%H:%M:%S'
echo -n '   - '
du -sh ../../gentoo2.tar.xz
echo
XZ_OPT=-9 bsdtar --exclude="usr/lib64/python*" -Jcf ../../gentoo3.tar.xz usr/lib64
echo -n 'OK - '
date '+%H:%M:%S'
echo -n '   - '
du -sh ../../gentoo3.tar.xz
echo
XZ_OPT=-9 bsdtar -Jcf ../../gentoo4.tar.xz usr/share/man
echo -n 'OK - '
date '+%H:%M:%S'
echo -n '   - '
du -sh ../../gentoo4.tar.xz
echo
XZ_OPT=-9 bsdtar --exclude="usr/share/man" -Jcf ../../gentoo5.tar.xz usr/share
echo -n 'OK - '
date '+%H:%M:%S'
echo -n '   - '
du -sh ../../gentoo5.tar.xz
echo
echo -n 'Stop - '
date '+%H:%M:%S'
cd - &> /dev/null
