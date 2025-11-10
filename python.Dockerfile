# syntax=docker/dockerfile:1

# FIRST LINE IS VERY IMPORTANT. DO NOT MODIFY

FROM gentoo/stage3:amd64-nomultilib-openrc

# derived from https://github.com/projg2/gentoo-python-image/blob/master/Dockerfile

RUN <<-EOF
    set -e

    # configure portage
    echo '*/* ~amd64' >> /etc/portage/package.accept_keywords/base.conf
    echo 'dev-lang/python **' >> /etc/portage/package.accept_keywords/python.conf
    echo '*/* full-stdlib sqlite' >> /etc/portage/package.use/python.conf
    echo 'dev-vcs/git -perl' >> /etc/portage/package.use/git.conf

    # install ::gentoo
    wget --progress=dot:mega -O - https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz | tar -xz
    mv gentoo-master /var/db/repos/gentoo

    # main job
    emerge -1vnt --jobs dev-python/tox app-arch/lzip dev-lang/rust-bin dev-vcs/git \
        dev-python/pypy-exe-bin dev-lang/pypy3-exe-bin dev-db/sqlite dev-libs/mpdecimal dev-python/uv
    emerge -1v --jobs --nodeps dev-lang/python:{2.7,3.8,3.9,3.10,3.11,3.12,{3.13,3.14}{,t}} \
        dev-lang/pypy:{2.7,3.11}

    # cleanup
    rm -r /var/db/repos/* /var/cache/distfiles/*
EOF

CMD ["/bin/bash"]
