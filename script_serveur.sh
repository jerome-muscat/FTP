#!/bin/bash

sudo apt update && sudo apt upgrade && sudo apt install proftpd-* 
sudo apt install openssl && apt install openssh-server 

conf=/etc/proftpd/proftpd.conf
tls=/etc/proftpd/tls.conf

sudo chmod 777 $conf
sudo chmod 777 $tls

echo -e "<Anonymous ~ftp>\n\
 User ftp\n\
 Group nogroup\n\
 UserAlias anonymous ftp\n\
 DirFakeUser on ftp\n\
 DirFakeGroup on ftp\n\
 RequireValidShell off\n\
 MaxClients 10\n\
  <Directory *>\n\
   <Limit WRITE>\n\
    DenyAll\n\
   </Limit>\n\
  </Directory>\n\
</Anonymous>\n\
\n\
Include /etc/proftpd/tls.conf" >> $conf

sudo mkdir /etc/proftpd/ssl

sudo openssl req -x509 -days 30 -subj "/C=''/ST=''/L=''/CN=''/emailAddress=''" -newkey rsa:2048 -keyout /etc/proftpd/ssl/proftpd.key.pem -out /etc/proftpd/ssl/proftpd.cert.pem
 
sudo chmod 666 /etc/proftpd/ssl/proftpd.key.pem
sudo chmod 666 /etc/proftpd/ssl/proftpd.cert.pem

echo -e "<IfModule mod_tls.c>\n\
 TLSEngine on\n\
 TLSLog /var/log/proftpd/tls.log\n\
 TLSProtocol SSLv23\n\
 TLSRSACertificateFile /etc/proftpd/ssl/proftpd.cert.pem\n\
 TLSRSACertificateKeyFile /etc/proftpd/ssl/proftpd.key.pem\n\
 TLSVerifyClient off\n\
 TLSRequired on\n\
</IfModule>" >>$tls

sudo /etc/init.d/proftpd restart
sudo chmod 644 $conf
sudo chmod 644 $tls

sudo useradd -m Merry
sudo useradd -m Pippin

echo "Merry:kalimac" | sudo chpasswd
echo "Merry:secondbreakfast" | sudo chpasswd
