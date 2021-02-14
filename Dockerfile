FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ENV PRITUNL_CONFIG=
ENV PRITUNL_MAIN_CONFIG=/etc/pritunl.conf

EXPOSE 9700
EXPOSE 443
EXPOSE 80
EXPOSE 1194

ENTRYPOINT ["/init"]

ENV VERSION="1.29.2664.67"

RUN apt-get update && apt-get install -y gnupg2 wget \
    && wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add - \
    && echo 'deb http://repo.pritunl.com/stable/apt bionic main' > /etc/apt/sources.list.d/pritunl.list \
    && echo "deb http://build.openvpn.net/debian/openvpn/stable bionic main" > /etc/apt/sources.list.d/openvpn-aptrepo.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 42F3E95A2C4F08279C4960ADD68FA50FEA312927 \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 8E6DA8B4E158C569 \
    && apt-get update -q \
    && apt-get install locales \
    && locale-gen en_US en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && apt-get upgrade -y -q \
    && apt-get dist-upgrade -y -q \
    && apt-get -y install pritunl="${VERSION}*" iptables netcat \
    && apt-get clean \
    && apt-get -y -q autoclean \
    && apt-get -y -q autoremove \
    && /usr/lib/pritunl/bin/python -m pip install 'mongo[srv]' dnspython \
    && rm -rf /tmp/*

ADD rootfs /
