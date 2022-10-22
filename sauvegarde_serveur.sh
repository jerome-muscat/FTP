#!/bin/bash

#cette commande permet d'afficher la date selon le format que l'on souhaite, ici : jj-mm-aaaa-HH-MM, et l'attribut à une variable précédemment nommé.
d=$(date +%d-%m-%Y-%H-%M)

#tar permet ici de créer un fichier compressé des dossier /home et /etc/proftp
sudo tar -czf /home/jerome/backup-$d.tar.gz /home /etc/proftpd 

#lftp est une commande qui permet d'envoyer une requête en se connectant en ftp
#Pour cela la connexion ftp doit être sous forme ftp://utilisateur:password@ip_serveur
#ici, elle permet d'envoyer le fichier compressé dans /home/jerome du serveur
lftp ftp://jerome:jerome@192.168.31.134 -e "put -O /home/jerome/ /home/jerome/backup-$d.tar.gz; quit"
