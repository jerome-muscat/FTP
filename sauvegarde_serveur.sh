sudo apt update && sudo apt-get install rsync

#cette commande permet d'afficher la date selon le format que l'on souhaite, ici : jj-mm-aaaa-HH-MM, et l'attribut à une variable précédemment nommé.
d=$(date +%d-%m-%Y-%H-%M)

sudo rsync -agloprtz /* jerome@192.168.87.1:C:\Users\jerom\Desktop\Backup-$d.tar.gz
