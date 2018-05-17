#!/bin/sh
#init
apt-get update
apt-get -y install --no-install-recommends apt-utils debconf-utils wget
export DEBIAN_FRONTEND="noninteractive"

#ssh
apt-get -y install --no-install-recommends openssh-server ca-certificates
useradd newuser
mkdir /var/run/sshd
echo "root:$DB_ROOT_PASS" | chpasswd
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
echo "export VISIBLE=now" >> /etc/profile
/etc/init.d/ssh start
#/usr/sbin/sshd

#php
echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add - apt update
apt-get update
apt-get -y install --no-install-recommends php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-msgpack php7.0-memcached php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-geoip php7.0-mbstring php7.0-xml php7.0-zip

#mysql
{
echo mysql-server-5.5 mysql-server/root-password password '';\
echo mysql-server-5.5 mysql-server/re-root-password password  '';\
} | debconf-set-selections
apt-get -y install --no-install-recommends mysql-server
/etc/init.d/mysql start
mysql mysql -u root
UPDATE user SET password=PASSWORD($DB_ROOT_PASS) WHERE user="root";
FLUSH PRIVILEGES;
EXIT;

#apache2
apt-get -y install --no-install-recommends apache2-utils apache2-data apache2
apt-get update
/etc/init.d/apache2 restart
