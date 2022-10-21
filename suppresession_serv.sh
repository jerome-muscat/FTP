#!/bin/bash

sudo rm /etc/proftpd/ssl/proftpd.cert.pem && sudo rm /etc/proftpd/ssl/proftp.key.pem
rm -r /home/Mery
rm -r /home/Pippin
sudo userdel Merry && sudo userdel Pippin
sudo apt --purge remove proftpd-*
