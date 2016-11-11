# First param is package tarball, 2nd is the *.DIGEST file
VerifyShaOfstage4()
{
	test_sum=$(awk -v myvar="$1" '$2==myvar {for(i=1; i<=1; i++) { print $1; exit}}' $2)
	calculated_sum=$(sha512sum $1 | awk '{print $1}' -)
	if [[ "$test_sum" == "$calculated_sum" ]]; then
		return 0
	else
		return 1
	fi
}

suffix=$3 # e.g. -hardened
arch=$1
dist="http://distfiles.gentoo.org/releases/${arch}/autobuilds/"
stage4path="$(wget -q -O- ${dist}/latest-stage4-${arch}${suffix}.txt | tail -n 1 | cut -f 1 -d ' ')"
stage4="$(basename ${stage4path})"

# Create working directory, keep a copy of busybox handy
mkdir newWorldOrder; cd newWorldOrder
cp /bin/busybox .

echo "Downloading and extracting ${stage4path}..."
wget -q -c "${dist}/${stage4path}" "${dist}/${stage4path}.DIGESTS"
if VerifyShaOfstage4 $stage4 "${stage4}.DIGESTS"; then
	echo "DIGEST sum is okey";
else
	echo "DIGEST sum is NOT okey";
	return 1;
fi
bunzip2 -c ${stage4} | tar --exclude "./etc/hosts" --exclude "./sys/*" -xf -
/newWorldOrder/busybox rm -f $stage4

echo "Installing stage 3"
/newWorldOrder/busybox rm -rf /lib* /usr /var /bin /sbin /opt /mnt /media /root /home /run /tmp
/newWorldOrder/busybox cp -fRap lib* /
/newWorldOrder/busybox cp -fRap bin boot home media mnt opt root run sbin tmp usr var /
/newWorldOrder/busybox cp -fRap etc/* /etc/

# Cleaning
cd /
/newWorldOrder/busybox rm -rf /newWorldOrder /build.sh /linuxrc

# Say hello
echo "Bootstrapped ${stage4path} into /:"
ls --color -lah
