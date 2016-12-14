FROM busybox

MAINTAINER Gentoo Docker Team
VOLUME /usr/portage:rw", /usr/portage/distfiles:rw, /usr/portage/distfiles:rw
# This one should be present by running the build.sh script
ADD build.sh /

RUN --privlaged /build.sh amd64 cloud

# Setup the (virtually) current runlevel
RUN --privlaged echo "default" > /run/openrc/softlevel

# Setup the rc_sys
RUN --privlaged sed -e 's/#rc_sys=""/rc_sys="lxc"/g' -i /etc/rc.conf

# Setup the net.lo runlevel
RUN --privlaged ln -s /etc/init.d/net.lo /run/openrc/started/net.lo

# Setup the net.eth0 runlevel
RUN --privlaged ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
RUN --privlaged ln -s /etc/init.d/net.eth0 /run/openrc/started/net.eth0

# By default, UTC system
RUN --privlaged echo 'UTC' > /etc/timezone
