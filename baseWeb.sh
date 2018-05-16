#!/bin/sh
apt-get update && apt-get install -y openssh-server wget
useradd newuser
mkdir /var/run/sshd
echo 'newuser:Tigrou007' | chpasswd
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

echo "export VISIBLE=now" >> /etc/profile

#php
echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add - apt update
apt-get update
apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-msgpack php7.0-memcached php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-geoip php7.0-mbstring php7.0-xml php7.0-zip

#mysql
apt-get -y install mariadb-server mariadb-client


#apache2
apt-get -y install apache2
