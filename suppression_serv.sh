#!/bin/bash

#rm permet de supprimer des fichiers. On peut lui assigner l'option -r pour pouvoir supprimer des dossiers.
sudo rm /etc/proftpd/ssl/proftpd.cert.pem && sudo rm /etc/proftpd/ssl/proftp.key.pem

#si on le souhaite, on peut supprimer des utilisateurs et leurs home.
#rm -r /home/Mery
#rm -r /home/Pippin
#sudo userdel Merry && sudo userdel Pippin

#apt --purge remove permet de désinstaller un ou plusieurs paquets.
sudo apt --purge remove proftpd-* 

#si on le souhaite, on peut désinstaller les paquets openssh et openssl.
#sudo apt --purge remove openssh-server
#sudo apt --purge remove openssl
