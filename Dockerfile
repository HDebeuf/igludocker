FROM debian:jessie-slim

ENV project-name project

#init and ssh
RUN apt-get update && apt-get install -y openssh-server wget
RUN useradd newuser
RUN mkdir /var/run/sshd
RUN echo 'newuser:Tigrou007' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#php
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add - apt update
RUN apt-get update
RUN apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-json php7.0-gd php7.0-mcrypt php7.0-msgpack php7.0-memcached php7.0-intl php7.0-sqlite3 php7.0-gmp php7.0-geoip php7.0-mbstring php7.0-xml php7.0-zip

#mysql
RUN apt-get -y install mariadb-server mariadb-client


#apache2
RUN apt-get -y install apache2

EXPOSE 22,80,3306
CMD ["/usr/sbin/sshd", "-D"]
