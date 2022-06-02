#!/bin/bash

#install webserver using this command, needed for apache, we will use package manager called yum
yum install -y httpd

#to start apache in your VM
systemctl start httpd

#needed for firewalld to allow traffic to the webserver, normal traffic uses port 80 while encrypted web traffic uses port 443
firewall-cmd --permanent --add-port=80/tcp

firewall-cmd --permanent --add-port=443/tcp

#need to reload the firewall to apply the changes.
firewall-cmd --reload

#this is to enable apache to start on boot.
systemctl enable httpd

#needed packages to install
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm

yum install -y yum-utils

yum-config-manager --enable remi-php56

#these are needed to install PHP modules to enhance the functionality of PHP
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo

#restart the webserver to apply the changes above.
systemctl restart httpd

#to install the the software helper known as MariaDB package so that our components can communicate with eachother.

#to install the the software helper known as MariaDB package so that our components can communicate with eachother.
yum install -y mariadb-server mariadb

#after installing, you need to start mariadb with this command.
systemctl start mariadb

#after it is running, you need a simple security script that removes dangerous defaults and lock down access to your database system.
mysql_secure_installation

#this is to enable mariadb on boot.
systemctl enable mariadb

#to login and start
mysql -u root -p
