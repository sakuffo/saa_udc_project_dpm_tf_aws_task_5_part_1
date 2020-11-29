#!/bin/bash
sudo su
yum -y install httpd
wget http://169.254.169.254/latest/meta-data/public-hostname \
DNS_NAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
echo "<p> My Instance! PRIMARY VPC! This is host: $DNS_NAME </p>" >> /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd