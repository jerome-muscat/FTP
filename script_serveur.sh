#!/bin/bash

sudo apt update && sudo apt upgrade && sudo apt install proftpd-*

conf=$(sudo /etc/proftpd/proftpd.conf)
tls=$(sudo /etc/proftpd/tls.conf)

echo "<Anonymous ~ftp>" >> $conf
echo " User ftp" >> $conf
echo " Group nogroup" >> $conf
echo " UserAlias anonymous ftp" >> $conf
echo " DirFakeUser on ftp" >> $conf
echo " DirFakeGroup on ftp" >> $conf
echo " RequireValidShell off" >> $conf
echo " MaxClients 10" >> $conf
echo " <Directory *" >> $conf
echo "  <Limit Write>" >> $conf
echo "   DenyAll" >> $conf
echo "  </Limit>" >> $conf
echo " </Directory>" >> $conf
echo "</Anonymous>" >> $conf
echo "Include /etc/proftpd/tls.conf" >> $conf

sudo mkdir /etc/proftpd/shell

sudo openssl req -newkey rsa:4096 -x509 -keyout /etc/proftpd/ssl/proftpd.key.pem -days 30 -nodes -out /etc/proftpd/ssl/proftpd.cert.pem 

sudo chmod 666 /etc/proftpd/ssl/proftpd.key.pem
sudo chmod 666 /etc/proftpd/ssl/proftpd.cert.pem

echo "<IfModule mod_tls.c>" >> $tls
echo " TLSEngine on" >> $tls
echo " TLSLog /var/log/proftpd/tls.log" >> $tls
echo " TLSProtocol SSLv23" >> $tls
echo " TLSRSACertificateFile /etc/proftpd/ssl/proftpd.cert.pem" >> $tls
echo " TLSRSACertificateKeyFile /etc/proftpd/ssl/proftpd.key.pem" >> $tls
echo " TLSVerifyClient off" >> $tls
echo " TLSRequired on" >> $tls
echo "</IfModule>" >> $tls

sudo /etc/init.d/proftpd restart
