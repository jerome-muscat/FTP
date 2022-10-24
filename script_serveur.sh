#!/bin/bash

#ces comandes permettent de mettre à jour tous le système, d'installer tous les paquets proftpd.
#Elles permettent aussi d'installer les protocoles de sécurité openssl et openssh.
sudo apt update && sudo apt upgrade && sudo apt install proftpd-* 
sudo apt install openssl && sudo apt install openssh-server 

#ces commandes permettent d'assigner une variable à un chemin d'accès à un fichier.
conf=/etc/proftpd/proftpd.conf
tls=/etc/proftpd/tls.conf

#chmod permet de modifier les droits, ici ce dernier donne tous les droits d'accès grâce à la valeur 777.
sudo chmod 777 $conf
sudo chmod 777 $tls

#echo permet ici dafficher écrire un paragraphe, grâce aux deux chevrons de le redériger sans écraser le fichier cité.
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

#mkdir permet de créer un dossier
sudo mkdir /etc/proftpd/ssl

#openssl req permet ici de créer une clé utilisant le protocol RSA et de le certifié en l'autosignant.
sudo openssl req -x509 -days 30 -subj "/C=''/ST=''/L=''/CN=''/emailAddress=''" -newkey rsa:2048 -keyout /etc/proftpd/ssl/proftpd.key.pem -out /etc/proftpd/ssl/proftpd.cert.pem
 
#chmod ici permet de donner les droits d'écriture et de lecture à tous les utilisateurs pour les fichiers générés par la commande précédente
sudo chmod 666 /etc/proftpd/ssl/proftpd.key.pem
sudo chmod 666 /etc/proftpd/ssl/proftpd.cert.pem

#echo permet ici d'écrire un paragraphe dans le fichier tls.conf sans l'écraser.
echo -e "<IfModule mod_tls.c>\n\
 TLSEngine on\n\
 TLSLog /var/log/proftpd/tls.log\n\
 TLSProtocol SSLv23\n\
 TLSRSACertificateFile /etc/proftpd/ssl/proftpd.cert.pem\n\
 TLSRSACertificateKeyFile /etc/proftpd/ssl/proftpd.key.pem\n\
 TLSVerifyClient off\n\
 TLSRequired on\n\
</IfModule>" >> $tls

#cette commande permet de faire redémarrer le service proftpd
sudo /etc/init.d/proftpd restart

#chmod permet ici de donnée le droit de lecture à tous les utilisateurs. Mais aussi, pour le propriétaire des documents, le droit d'écriture.
sudo chmod 644 $conf
sudo chmod 644 $tls

#useradd -m permet de créer des utilisateurs en leur assignant un home dédié.
sudo useradd -m Merry
sudo useradd -m Pippin

#ces commandes permettent de modifié les mots de passe d'un utilisateur.
echo "Merry:kalimac" | sudo chpasswd
echo "Merry:secondbreakfast" | sudo chpasswd
