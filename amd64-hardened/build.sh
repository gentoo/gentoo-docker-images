stage3_suffix="-hardened"
dist="http://distfiles.gentoo.org/releases/amd64/autobuilds"
stage3="$(busybox wget -qO- $dist/latest-stage3-amd64${suffix}.txt | busybox tail -n 1)"

busybox echo "Downloading and extracting ${stage3}..."
busybox wget "${dist}/${stage3}" -qO- \
  | busybox tar \
    --exclude="./etc/hosts" \
    --exclude="./sys/*" \
    -pxjf -

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
rm /Dockerfile
rm /build.sh

echo "Bootstrapped ${stage3} into /:"
ls --color -lah
