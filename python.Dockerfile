FROM gentoo/stage3:amd64-nomultilib-openrc

# derived from https://github.com/projg2/gentoo-python-image/blob/master/Dockerfile

RUN echo '*/* ~amd64' >> /etc/portage/package.accept_keywords/base.conf \
 && echo '*/* full-stdlib sqlite' >> /etc/portage/package.use/python \
 && echo 'dev-vcs/git -perl' >> /etc/portage/package.use/git \
 && wget --progress=dot:mega -O - https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz | tar -xz \
 && mv gentoo-master /var/db/repos/gentoo \
 && emerge -1vnt --jobs dev-python/tox app-arch/lzip dev-vcs/git \
    dev-python/pypy{,3_9,3_10}-exe-bin dev-db/sqlite \
 && emerge -1v --jobs --nodeps dev-lang/python:{2.7,3.8,3.9,3.10,3.11,3.12} \
    dev-python/pypy{,3_9,3_10,3} \
 && rm -r /var/db/repos/* /var/cache/distfiles/*

CMD ["/bin/bash"]
