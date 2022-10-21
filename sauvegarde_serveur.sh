#cette commande permet d'afficher la date selon le format que l'on souhaite, ici : jj-mm-aaaa-HH-MM, et l'attribut à une variable précédemment nommé.
d=$(date +%d-%m-%Y-%H-%M)

sudo tar -czf /home/jerome/backup-$d.tar.gz /home /etc/proftpd 

lftp ftp://jerome:jerome@192.168.31.134 -e "put -O /home/jerome/ /home/jerome/backup-$d.tar.gz; quit"
