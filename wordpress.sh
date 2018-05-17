#!/bin/sh

#database
CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'mypassword';
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON wordpress.* TO 'newuser'@'localhost' IDENTIFIED BY 'mypassword';
FLUSH PRIVILEGES;
EXIT;

#apache2
a2enmod rewrite
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

#adminer
mkdir /usr/share/adminer
wget "https://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php
mv /usr/share/adminer/latest.php /usr/share/adminer/index.php
echo "Alias /usr/share/adminer/adminer.php /usr/share/adminer/adminer.php" | tee /etc/apache2/conf-available/adminer.conf
a2enconf adminer.conf
service apache2 restart

a2enmod ssl
openssl genrsa -des3 -passout pass:mypassword -out adminer-project.iglu.com.key 2048 -noout
openssl rsa -in adminer-project.iglu.com.key -passin pass:mypassword -out adminer-project.iglu.com.key
openssl req -new -key adminer-project.iglu.com.key -out adminer-project.iglu.com.csr -passin pass:mypassword \
    -subj "/C=BE/ST=Luxembourg/L=Marche-en-Famenne/O=iglu/OU=devops/CN=adminer-project.iglu.com/emailAddress=admin@project.iglu.com"
openssl x509 -req -days 365 -in adminer-project.iglu.com.csr -signkey adminer-project.iglu.com.key -out adminer-project.iglu.com.crt
mv adminer-project.iglu.com.key /etc/ssl/private/adminer-project.iglu.com.key
mv adminer-project.iglu.com.crt /etc/ssl/private/adminer-project.iglu.com.crt
service apache2 restart

touch /etc/apache2/sites-available/adminer_dashboard.conf
cat > /etc/apache2/sites-available/adminer_dashboard.conf <<- EOM
<IfModule mod_ssl.c>
<VirtualHost *:80>
      # Configuration de l'addresse
      ServerAdmin 	admin@project.com
      ServerName  	adminer-project.iglu.com

      DocumentRoot	/usr/share/adminer


      # Redirection vers HTTPS
      RewriteEngine   on
      RewriteCond 	%{HTTPS} !=on
      RewriteRule 	^(.*)$ https://%{SERVER_NAME}$1 [L,R=301]
</VirtualHost>

<IfModule mod_ssl.c>
<VirtualHost *:443>
      # Configuration de l'addresse
      ServerAdmin admin@project.iglu.com
      ServerName adminer-project.iglu.com
      DocumentRoot /usr/share/adminer

      # Utilisation de la clé et du certificat
      SSLEngine   	on
      SSLCertificateFile  	/etc/ssl/private/adminer-project.iglu.com.crt
      SSLCertificateKeyFile   /etc/ssl/private/adminer-project.iglu.com.key
      SSLProxyEngine  on

</VirtualHost>
</IfModule>
EOM

a2ensite adminer_dashboard.conf

service apache2 restart
