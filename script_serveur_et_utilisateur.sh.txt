#!/bin/bash

#Cette commande permet de définir le séparateur de tableau comme étant une virgule
export IFS=","

#cat permet de lire un fichier, ici le tableau contenant les utilisateurs
#Ensuite while read permet de créer une boucle et des variables, et de les associer aux colonnes du tableau.
  #Puis comme le document est lu ligne par ligne, j'exécute les commandes :
  #sudo userdel permet de supprimer des utilisateurs, ici grâce aux variables, ceux du tableau.
  #sudo goupdel permet de supprimer des groupes, ici grâce aux variables, ceux du tableau.
  #sudo useradd permet de créer des utilisateurs, ici grâce aux variables, ceux du tableau.
  #echo et sudo chpasswd permet de définir des mots de passe, ici grâce aux variables, ceux du tableau.
  #sudo usermod permet ici grâce à l'option -u de créer des UID, celles ci correspond à celles du tableau
  #grâce à la boucle if, je regarde si la condition est correcte. Si oui, alors grâce à usemod -aG j'ajoute l'utilisateur au groupe sudo 
	
cat /home/jerome/GitHub/shell.exe/Job_9/Shell_Userlist.csv | while read Id Prenom Nom Mdp Role	
	do
	sudo useradd -m $Prenom-$Nom
        echo "$Prenom-$Nom:$Mdp" | sudo chpasswd
        sudo usermod -u $Id "$Prenom-$Nom"
                if [ $Role = "Admin" ]
                then
                sudo usermod -aG sudo "$Prenom-$Nom"
                fi
        done

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
