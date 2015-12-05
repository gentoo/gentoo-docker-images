#!/bin/bash

cp -p update.sh system/root/ &> /dev/null
mount -t proc proc system/proc/
mount --rbind /dev/ system/dev/
mount --rbind /sys/ system/sys/

chroot system/ /bin/bash

umount -l system/proc/ system/dev/ system/sys/
rm system/root/update.sh &> /dev/null
